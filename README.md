# sgalgaR: a package for determining SGA and LGA babies.

Babies born small for gestational age ([SGA](https://en.wikipedia.org/wiki/Small_for_gestational_age)) or large for gestational age ([LGA](https://en.wikipedia.org/wiki/Large_for_gestational_age)) have a higher risk of morbidity and mortality.  Small is often defined as <= 10<sup>th</sup> percentile given the baby's sex and gestational age, or <= 3<sup>rd</sup> percential given the baby's sex and gestational age. Similarly, LGA is often defined in temrs of the 90<sup>th</sup>.

Finding look-up tables is straightforward enough, but these are not particularly useful for processing millions of records.  This trivial package gives a percentile classifications (weight for gestational age and sex) for a single infant (ga_class()) or a dataframe of millions of infants (ga_dataframe()).

The possible percential classes are:
"<= 03", "<= 05", "<= 10", "10-90", ">= 90", ">= 95", ">= 97"

When processing a dataframe, the entire dataframe is returned with an additional column (ga_class)

### Note
The classifications are based on US data.

### Reference
Talge NM, Mudd LM, Sikorskii A, Basso O.  United States birth weight reference corrected for implausible gestational age estimates. __Pediatrics__; 2014 May;133(5):844-53. doi: 10.1542/peds.2013-3285. https://www.ncbi.nlm.nih.gov/pubmed/24777216

