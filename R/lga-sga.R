########################################################################################################################
#                                                                                                                      #
#                                                                                                                      #
#                                                                                                                      #
#                                                                                                                      #
########################################################################################################################

#' @title Calculate a single percentile class of birthweight
#'
#' @param ga An integer representing a neonate's gestational age in weeks
#' @param bsex A character indicating sex ("M"/"F")
#' @param birthweight An integer representing birthweight in grams
#'
#' @return A string representing the percentile class of birthweight given gestational age and sex
#' @export
#'
#' @examples
#' ga_class(ga = 25, bsex = "M", birthweight = 2521)
ga_class <- function(ga, bsex, birthweight){
  # Isolate the relevant row of the  Gestational Age data based on gestational age and neonatal sex
  lookupdata <- lsgaDF %>% dplyr::filter(week == ga & sex == bsex)  %>% dplyr::select(p03:p97)
  lookupdata <- unlist(lookupdata)
  # Figure out how many percentiles the lookup birthweight is larger than
  small <- length(which(lookupdata < birthweight))
  # Figure out how many percentiles the lookup birthweight is less than
  large <- length(which(lookupdata > birthweight))

  # Work through the if-then rules to locate the correct poercentile for the birthweight (given gestational age and sex)
  if(abs(small - large) <= 1){
    bwtcat = ">10 <90"
  }
  if(small == 0){
    bwtcat = "<= 03"
  }
  if(small == 1 & (large == 5 | large == 6)){
    bwtcat = "<= 05"
  }
  if(small == 2 & (large == 4 | large == 5)){
    bwtcat = "<= 10"
  }
  if(large == 2 & (small == 4 | small == 5)){
    bwtcat = ">= 90"
  }
  if(large == 1 & (small == 5 | small == 6)){
    bwtcat = ">= 95"
  }
  if(large == 0){
    bwtcat = ">= 97"
  }

    return( bwtcat )
}



#' @title Calculate a percentile class of birthweight over a dataframe
#'
#' @param DF A dataframe containing columns for (at least) gestational age, sex, and birthweight
#' @param gestation_age A column of integers representing neonates' gestational age in weeks
#' @param neonate_sex A column of characters indicating sex ("M"/"F")
#' @param birthweight A column of integers representing birthweight in grams
#'
#' @return DF with an additional column (gest_cat) representingthe percentile class of birthweight
#' @export
#'
#' @examples
#' ga_dataframe(A_DataFrame)
#' ga_dataframe(A_DataFrame, gestation_age = "my_gest", neonate_sex = "my_sex", birthweight = "my_bwt"
ga_dataframe <- function(DF,  gestation_age = "combgest", neonate_sex = "sex", birthweight = "dbwt") {
  # The next two lines reduces a dataframe of getational age, sex, and birthweight into a dataframe of
  # unique rows.  In a very large birth-file (I'm working with >10 Million births), there is a lot of repetition
  # Stripping out the repetition speeds everything up.  tmpDF ends up as a three column dataframe
  tmpDF <- DF %>% dplyr::select_(gestation_age, neonate_sex, birthweight) %>%  dplyr::arrange_(gestation_age, neonate_sex, birthweight)
  tmpDF <- dplyr::distinct(tmpDF)

  # Add the gestational category (percentiles) the the new dataframe.  The ga_class() function is applied
  # to each row in turn of tmpDF
  tmpDF$gest_cat <- apply(tmpDF, 1, function(x, v1, v2, v3) {ga_class(x[v1], x[v2], x[v3])}, gestation_age, neonate_sex, birthweight)

  # Use a left join to stitch the gestational category (percentile) to the original dataframe
  dplyr::left_join(DF, tmpDF, by = c(gestation_age, neonate_sex, birthweight ))
}
