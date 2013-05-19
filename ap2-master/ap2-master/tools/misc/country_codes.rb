CODES = {
  "1" => {:name => "United States", :special_case => true, :country_name_2_letters => "US", :country_name_3_letters => "USA", :min_cns => 4, :max_cns => 7},
  "7" => {:name => "Russia", :special_case => true, :country_name_2_letters => "RU", :country_name_3_letters => "RUS", :min_cns => 2, :max_cns => 8},
  "20" => {:name => "Egypt", :special_case => false, :country_name_2_letters => "EG", :country_name_3_letters => "EGY", :min_cns => 3, :max_cns => 5},
  "27" => {:name => "South Africa", :special_case => false, :country_name_2_letters => "ZA", :country_name_3_letters => "ZAF", :min_cns => 4, :max_cns => 5},
  "30" => {:name => "Greece", :special_case => false, :country_name_2_letters => "GR", :country_name_3_letters => "GRC", :min_cns => 4, :max_cns => 9},
  "31" => {:name => "Netherlands", :special_case => false, :country_name_2_letters => "NL", :country_name_3_letters => "NLD", :min_cns => 3, :max_cns => 11},
  "32" => {:name => "Belgium", :special_case => false, :country_name_2_letters => "BE", :country_name_3_letters => "BEL", :min_cns => 3, :max_cns => 8},
  "33" => {:name => "France", :special_case => false, :country_name_2_letters => "FR", :country_name_3_letters => "FRA", :min_cns => 3, :max_cns => 8},
  "34" => {:name => "Spain", :special_case => true, :country_name_2_letters => "ES", :country_name_3_letters => "ESP", :min_cns => 3, :max_cns => 10},
  "36" => {:name => "Hungary", :special_case => false, :country_name_2_letters => "HU", :country_name_3_letters => "HUN", :min_cns => 3, :max_cns => 7},
  "39" => {:name => "Italy", :special_case => false, :country_name_2_letters => "IT", :country_name_3_letters => "ITA", :min_cns => 3, :max_cns => 11},
  "40" => {:name => "Romania", :special_case => false, :country_name_2_letters => "RO", :country_name_3_letters => "ROU", :min_cns => 4, :max_cns => 5},
  "41" => {:name => "Switzerland", :special_case => false, :country_name_2_letters => "CH", :country_name_3_letters => "CHE", :min_cns => 4, :max_cns => 8},
  "43" => {:name => "Austria", :special_case => false, :country_name_2_letters => "AT", :country_name_3_letters => "AUT", :min_cns => 3, :max_cns => 9},
  "44" => {:name => "United Kingdom", :special_case => true, :country_name_2_letters => "GB", :country_name_3_letters => "GBR", :min_cns => 3, :max_cns => 9},
  "45" => {:name => "Denmark", :special_case => false, :country_name_2_letters => "DK", :country_name_3_letters => "DNK", :min_cns => 3, :max_cns => 8},
  "46" => {:name => "Sweden", :special_case => false, :country_name_2_letters => "SE", :country_name_3_letters => "SWE", :min_cns => 3, :max_cns => 10},
  "47" => {:name => "Norway", :special_case => true, :country_name_2_letters => "NO", :country_name_3_letters => "NOR", :min_cns => 3, :max_cns => 8},
  "48" => {:name => "Poland", :special_case => false, :country_name_2_letters => "PL", :country_name_3_letters => "POL", :min_cns => 4, :max_cns => 8},
  "49" => {:name => "Germany", :special_case => false, :country_name_2_letters => "DE", :country_name_3_letters => "DEU", :min_cns => 4, :max_cns => 10},
  "51" => {:name => "Peru", :special_case => false, :country_name_2_letters => "PE", :country_name_3_letters => "PER", :min_cns => 3, :max_cns => 9},
  "52" => {:name => "Mexico", :special_case => false, :country_name_2_letters => "MX", :country_name_3_letters => "MEX", :min_cns => 3, :max_cns => 9},
  "53" => {:name => "Cuba", :special_case => false, :country_name_2_letters => "CU", :country_name_3_letters => "CUB", :min_cns => 3, :max_cns => 10},
  "54" => {:name => "Argentina", :special_case => false, :country_name_2_letters => "AR", :country_name_3_letters => "ARG", :min_cns => 3, :max_cns => 12},
  "55" => {:name => "Brazil", :special_case => false, :country_name_2_letters => "BR", :country_name_3_letters => "BRA", :min_cns => 4, :max_cns => 7},
  "56" => {:name => "Chile", :special_case => false, :country_name_2_letters => "CL", :country_name_3_letters => "CHL", :min_cns => 3, :max_cns => 8},
  "57" => {:name => "Colombia", :special_case => false, :country_name_2_letters => "CO", :country_name_3_letters => "COL", :min_cns => 3, :max_cns => 10},
  "58" => {:name => "Venezuela", :special_case => false, :country_name_2_letters => "VE", :country_name_3_letters => "VEN", :min_cns => 3, :max_cns => 8},
  "60" => {:name => "Malaysia", :special_case => false, :country_name_2_letters => "MY", :country_name_3_letters => "MYS", :min_cns => 3, :max_cns => 8},
  "61" => {:name => "Australia", :special_case => true, :country_name_2_letters => "AU", :country_name_3_letters => "AUS", :min_cns => 3, :max_cns => 9},
  "62" => {:name => "Indonesia", :special_case => false, :country_name_2_letters => "ID", :country_name_3_letters => "IDN", :min_cns => 3, :max_cns => 5},
  "63" => {:name => "Philippines", :special_case => false, :country_name_2_letters => "PH", :country_name_3_letters => "PHL", :min_cns => 3, :max_cns => 7},
  "64" => {:name => "New Zealand", :special_case => true, :country_name_2_letters => "NZ", :country_name_3_letters => "NZL", :min_cns => 3, :max_cns => 6},
  "65" => {:name => "Singapore", :special_case => false, :country_name_2_letters => "SG", :country_name_3_letters => "SGP", :min_cns => 3, :max_cns => 6},
  "66" => {:name => "Thailand", :special_case => false, :country_name_2_letters => "TH", :country_name_3_letters => "THA", :min_cns => 3, :max_cns => 5},
  "81" => {:name => "Japan", :special_case => false, :country_name_2_letters => "JP", :country_name_3_letters => "JPN", :min_cns => 3, :max_cns => 7},
  "82" => {:name => "Korea; South", :special_case => false, :country_name_2_letters => "KR", :country_name_3_letters => "KOR", :min_cns => 3, :max_cns => 6},
  "84" => {:name => "Vietnam", :special_case => false, :country_name_2_letters => "VN", :country_name_3_letters => "VNM", :min_cns => 3, :max_cns => 7},
  "86" => {:name => "China", :special_case => true, :country_name_2_letters => "CN", :country_name_3_letters => "CHN", :min_cns => 4, :max_cns => 7},
  "90" => {:name => "Turkey", :special_case => false, :country_name_2_letters => "TR", :country_name_3_letters => "TUR", :min_cns => 3, :max_cns => 5},
  "91" => {:name => "India", :special_case => false, :country_name_2_letters => "IN", :country_name_3_letters => "IND", :min_cns => 3, :max_cns => 6},
  "92" => {:name => "Pakistan", :special_case => false, :country_name_2_letters => "PK", :country_name_3_letters => "PAK", :min_cns => 4, :max_cns => 5},
  "93" => {:name => "Afghanistan", :special_case => false, :country_name_2_letters => "AF", :country_name_3_letters => "AFG", :min_cns => 4, :max_cns => 6},
  "94" => {:name => "Sri Lanka", :special_case => false, :country_name_2_letters => "LK", :country_name_3_letters => "LKA", :min_cns => 4, :max_cns => 8},
  "95" => {:name => "Myanmar", :special_case => false, :country_name_2_letters => "MM", :country_name_3_letters => "MMR", :min_cns => 3, :max_cns => 6},
  "98" => {:name => "Iran", :special_case => false, :country_name_2_letters => "IR", :country_name_3_letters => "IRN", :min_cns => 4, :max_cns => 9},
  "212" => {:name => "Morocco", :special_case => true, :country_name_2_letters => "MA", :country_name_3_letters => "MAR", :min_cns => 4, :max_cns => 8},
  "213" => {:name => "Algeria", :special_case => false, :country_name_2_letters => "DZ", :country_name_3_letters => "DZA", :min_cns => 4, :max_cns => 8},
  "216" => {:name => "Tunisia", :special_case => false, :country_name_2_letters => "TN", :country_name_3_letters => "TUN", :min_cns => 4, :max_cns => 8},
  "218" => {:name => "Libya", :special_case => false, :country_name_2_letters => "LY", :country_name_3_letters => "LBY", :min_cns => 5, :max_cns => 6},
  "220" => {:name => "Gambia", :special_case => false, :country_name_2_letters => "GM", :country_name_3_letters => "GMB", :min_cns => 4, :max_cns => 7},
  "221" => {:name => "Senegal", :special_case => false, :country_name_2_letters => "SN", :country_name_3_letters => "SEN", :min_cns => 5, :max_cns => 7},
  "222" => {:name => "Mauritania", :special_case => false, :country_name_2_letters => "MR", :country_name_3_letters => "MRT", :min_cns => 4, :max_cns => 7},
  "223" => {:name => "Mali", :special_case => false, :country_name_2_letters => "ML", :country_name_3_letters => "MLI", :min_cns => 4, :max_cns => 8},
  "224" => {:name => "Guinea", :special_case => false, :country_name_2_letters => "GN", :country_name_3_letters => "GIN", :min_cns => 5, :max_cns => 8},
  "225" => {:name => "CÙte d'Ivoire", :special_case => false, :country_name_2_letters => "CI", :country_name_3_letters => "CIV", :min_cns => 5, :max_cns => 6},
  "226" => {:name => "Burkina Faso", :special_case => false, :country_name_2_letters => "BF", :country_name_3_letters => "BFA", :min_cns => 5, :max_cns => 11},
  "227" => {:name => "Niger", :special_case => false, :country_name_2_letters => "NE", :country_name_3_letters => "NER", :min_cns => 5, :max_cns => 9},
  "228" => {:name => "Togo", :special_case => false, :country_name_2_letters => "TG", :country_name_3_letters => "TGO", :min_cns => 4, :max_cns => 6},
  "229" => {:name => "Benin", :special_case => false, :country_name_2_letters => "BJ", :country_name_3_letters => "BEN", :min_cns => 5, :max_cns => 11},
  "230" => {:name => "Mauritius", :special_case => false, :country_name_2_letters => "MU", :country_name_3_letters => "MUS", :min_cns => 5, :max_cns => 10},
  "231" => {:name => "Liberia", :special_case => false, :country_name_2_letters => "LR", :country_name_3_letters => "LBR", :min_cns => 4, :max_cns => 5},
  "232" => {:name => "Sierra Leone", :special_case => false, :country_name_2_letters => "SL", :country_name_3_letters => "SLE", :min_cns => 5, :max_cns => 7},
  "233" => {:name => "Ghana", :special_case => false, :country_name_2_letters => "GH", :country_name_3_letters => "GHA", :min_cns => 5, :max_cns => 8},
  "234" => {:name => "Nigeria", :special_case => false, :country_name_2_letters => "NG", :country_name_3_letters => "NGA", :min_cns => 4, :max_cns => 7},
  "235" => {:name => "Chad", :special_case => false, :country_name_2_letters => "TD", :country_name_3_letters => "TCD", :min_cns => 4, :max_cns => 8},
  "236" => {:name => "Central African Republic", :special_case => false, :country_name_2_letters => "CF", :country_name_3_letters => "CAF", :min_cns => 5, :max_cns => 11},
  "237" => {:name => "Cameroon", :special_case => false, :country_name_2_letters => "CM", :country_name_3_letters => "CMR", :min_cns => 4, :max_cns => 7},
  "238" => {:name => "Cape Verde", :special_case => false, :country_name_2_letters => "CV", :country_name_3_letters => "CPV", :min_cns => 5, :max_cns => 6},
  "239" => {:name => "S„o TomÈ and PrÌncipe", :special_case => false, :country_name_2_letters => "ST", :country_name_3_letters => "STP", :min_cns => 4, :max_cns => 5},
  "240" => {:name => "Equatorial Guinea", :special_case => false, :country_name_2_letters => "GQ", :country_name_3_letters => "GNQ", :min_cns => 5, :max_cns => 5},
  "241" => {:name => "Gabon", :special_case => false, :country_name_2_letters => "GA", :country_name_3_letters => "GAB", :min_cns => 4, :max_cns => 7},
  "242" => {:name => "Congo-Brazzaville", :special_case => false, :country_name_2_letters => "CG", :country_name_3_letters => "COG", :min_cns => 4, :max_cns => 6},
  "243" => {:name => "Congo; DR", :special_case => false, :country_name_2_letters => "CD", :country_name_3_letters => "COD", :min_cns => 4, :max_cns => 7},
  "244" => {:name => "Angola", :special_case => false, :country_name_2_letters => "AO", :country_name_3_letters => "AGO", :min_cns => 5, :max_cns => 9},
  "245" => {:name => "Guinea-Bissau", :special_case => false, :country_name_2_letters => "GW", :country_name_3_letters => "GNB", :min_cns => 4, :max_cns => 6},
  "246" => {:name => "British Indian Ocean Territory", :special_case => true, :country_name_2_letters => "IO", :country_name_3_letters => "IOT", :min_cns => 4, :max_cns => 10},
  "247" => {:name => "Ascension Island", :special_case => false, :country_name_2_letters => "AC", :country_name_3_letters => "ASC", :min_cns => 4, :max_cns => 5},
  "248" => {:name => "Seychelles", :special_case => false, :country_name_2_letters => "SC", :country_name_3_letters => "SYC", :min_cns => 6, :max_cns => 7},
  "249" => {:name => "Sudan", :special_case => false, :country_name_2_letters => "SD", :country_name_3_letters => "SDN", :min_cns => 4, :max_cns => 9},
  "250" => {:name => "Rwanda", :special_case => false, :country_name_2_letters => "RW", :country_name_3_letters => "RWA", :min_cns => 4, :max_cns => 9},
  "251" => {:name => "Ethiopia", :special_case => false, :country_name_2_letters => "ET", :country_name_3_letters => "ETH", :min_cns => 5, :max_cns => 9},
  "252" => {:name => "Somalia", :special_case => true, :country_name_2_letters => "SO", :country_name_3_letters => "SOM", :min_cns => 4, :max_cns => 10},
  "253" => {:name => "Djibouti", :special_case => false, :country_name_2_letters => "DJ", :country_name_3_letters => "DJI", :min_cns => 4, :max_cns => 5},
  "254" => {:name => "Kenya", :special_case => false, :country_name_2_letters => "KE", :country_name_3_letters => "KEN", :min_cns => 4, :max_cns => 9},
  "255" => {:name => "Tanzania", :special_case => false, :country_name_2_letters => "TZ", :country_name_3_letters => "TZA", :min_cns => 4, :max_cns => 12},
  "256" => {:name => "Uganda", :special_case => false, :country_name_2_letters => "UG", :country_name_3_letters => "UGA", :min_cns => 4, :max_cns => 9},
  "257" => {:name => "Burundi", :special_case => false, :country_name_2_letters => "BI", :country_name_3_letters => "BDI", :min_cns => 5, :max_cns => 7},
  "258" => {:name => "Mozambique", :special_case => false, :country_name_2_letters => "MZ", :country_name_3_letters => "MOZ", :min_cns => 4, :max_cns => 9},
  "260" => {:name => "Zambia", :special_case => false, :country_name_2_letters => "ZM", :country_name_3_letters => "ZMB", :min_cns => 4, :max_cns => 7},
  "261" => {:name => "Madagascar", :special_case => false, :country_name_2_letters => "MG", :country_name_3_letters => "MDG", :min_cns => 4, :max_cns => 10},
  "262" => {:name => "RÈunion", :special_case => true, :country_name_2_letters => "RE", :country_name_3_letters => "REU", :min_cns => 6, :max_cns => 8},
  "263" => {:name => "Zimbabwe", :special_case => false, :country_name_2_letters => "ZW", :country_name_3_letters => "ZWE", :min_cns => 4, :max_cns => 7},
  "264" => {:name => "Namibia", :special_case => false, :country_name_2_letters => "NA", :country_name_3_letters => "NAM", :min_cns => 5, :max_cns => 12},
  "265" => {:name => "Malawi", :special_case => false, :country_name_2_letters => "MW", :country_name_3_letters => "MWI", :min_cns => 4, :max_cns => 7},
  "266" => {:name => "Lesotho", :special_case => false, :country_name_2_letters => "LS", :country_name_3_letters => "LSO", :min_cns => 4, :max_cns => 7},
  "267" => {:name => "Botswana", :special_case => false, :country_name_2_letters => "BW", :country_name_3_letters => "BWA", :min_cns => 4, :max_cns => 8},
  "268" => {:name => "Swaziland", :special_case => false, :country_name_2_letters => "SZ", :country_name_3_letters => "SWZ", :min_cns => 4, :max_cns => 7},
  "269" => {:name => "Comoros", :special_case => false, :country_name_2_letters => "KM", :country_name_3_letters => "COM", :min_cns => 5, :max_cns => 7},
  "290" => {:name => "Saint Helena", :special_case => true, :country_name_2_letters => "SH", :country_name_3_letters => "SHN", :min_cns => 4, :max_cns => 5},
  "291" => {:name => "Eritrea", :special_case => false, :country_name_2_letters => "ER", :country_name_3_letters => "ERI", :min_cns => 4, :max_cns => 6},
  "297" => {:name => "Aruba", :special_case => false, :country_name_2_letters => "AW", :country_name_3_letters => "ABW", :min_cns => 5, :max_cns => 7},
  "298" => {:name => "Faroe Islands", :special_case => false, :country_name_2_letters => "FO", :country_name_3_letters => "FRO", :min_cns => 5, :max_cns => 8},
  "299" => {:name => "Greenland", :special_case => false, :country_name_2_letters => "GL", :country_name_3_letters => "GRL", :min_cns => 5, :max_cns => 7},
  "351" => {:name => "Portugal", :special_case => false, :country_name_2_letters => "PT", :country_name_3_letters => "PRT", :min_cns => 5, :max_cns => 12},
  "352" => {:name => "Luxembourg", :special_case => false, :country_name_2_letters => "LU", :country_name_3_letters => "LUX", :min_cns => 4, :max_cns => 11},
  "353" => {:name => "Ireland", :special_case => false, :country_name_2_letters => "IE", :country_name_3_letters => "IRL", :min_cns => 4, :max_cns => 13},
  "354" => {:name => "Iceland", :special_case => false, :country_name_2_letters => "IS", :country_name_3_letters => "ISL", :min_cns => 4, :max_cns => 10},
  "355" => {:name => "Albania", :special_case => false, :country_name_2_letters => "AL", :country_name_3_letters => "ALB", :min_cns => 4, :max_cns => 6},
  "356" => {:name => "Malta", :special_case => false, :country_name_2_letters => "MT", :country_name_3_letters => "MLT", :min_cns => 5, :max_cns => 7},
  "357" => {:name => "Cyprus; Greek", :special_case => true, :country_name_2_letters => "CY", :country_name_3_letters => "CYP", :min_cns => 5, :max_cns => 11},
  "358" => {:name => "Finland", :special_case => true, :country_name_2_letters => "FI", :country_name_3_letters => "FIN", :min_cns => 4, :max_cns => 9},
  "359" => {:name => "Bulgaria", :special_case => false, :country_name_2_letters => "BG", :country_name_3_letters => "BGR", :min_cns => 4, :max_cns => 9},
  "370" => {:name => "Lithuania", :special_case => false, :country_name_2_letters => "LT", :country_name_3_letters => "LTU", :min_cns => 4, :max_cns => 11},
  "371" => {:name => "Latvia", :special_case => false, :country_name_2_letters => "LV", :country_name_3_letters => "LVA", :min_cns => 4, :max_cns => 7},
  "372" => {:name => "Estonia", :special_case => false, :country_name_2_letters => "EE", :country_name_3_letters => "EST", :min_cns => 4, :max_cns => 13},
  "373" => {:name => "Moldova", :special_case => true, :country_name_2_letters => "MD", :country_name_3_letters => "MDA", :min_cns => 5, :max_cns => 6},
  "374" => {:name => "Armenia", :special_case => true, :country_name_2_letters => "AM", :country_name_3_letters => "ARM", :min_cns => 5, :max_cns => 8},
  "375" => {:name => "Belarus", :special_case => false, :country_name_2_letters => "BY", :country_name_3_letters => "BLR", :min_cns => 5, :max_cns => 13},
  "376" => {:name => "Andorra", :special_case => false, :country_name_2_letters => "AD", :country_name_3_letters => "AND", :min_cns => 4, :max_cns => 7},
  "377" => {:name => "Kosovo", :special_case => true, :country_name_2_letters => "QK", :country_name_3_letters => "QKS", :min_cns => 5, :max_cns => 6},
  "378" => {:name => "San Marino", :special_case => false, :country_name_2_letters => "SM", :country_name_3_letters => "SMR", :min_cns => 4, :max_cns => 9},
  "379" => {:name => "Vatican City", :special_case => false, :country_name_2_letters => "VA", :country_name_3_letters => "VAT", :min_cns => 8, :max_cns => 8},
  "380" => {:name => "Ukraine", :special_case => false, :country_name_2_letters => "UA", :country_name_3_letters => "UKR", :min_cns => 5, :max_cns => 9},
  "381" => {:name => "Serbia", :special_case => false, :country_name_2_letters => "RS", :country_name_3_letters => "SRB", :min_cns => 4, :max_cns => 7},
  "382" => {:name => "Montenegro", :special_case => false, :country_name_2_letters => "ME", :country_name_3_letters => "MNE", :min_cns => 5, :max_cns => 6},
  "385" => {:name => "Croatia", :special_case => false, :country_name_2_letters => "HR", :country_name_3_letters => "HRV", :min_cns => 4, :max_cns => 7},
  "386" => {:name => "Slovenia", :special_case => false, :country_name_2_letters => "SI", :country_name_3_letters => "SVN", :min_cns => 4, :max_cns => 7},
  "387" => {:name => "Bosnia and Herzegovina", :special_case => false, :country_name_2_letters => "BA", :country_name_3_letters => "BIH", :min_cns => 5, :max_cns => 7},
  "388" => {:name => "European Union", :special_case => false, :country_name_2_letters => "EU", :country_name_3_letters => "", :min_cns => 4, :max_cns => 10},
  "389" => {:name => "Macedonia", :special_case => false, :country_name_2_letters => "MK", :country_name_3_letters => "MKD", :min_cns => 4, :max_cns => 5},
  "420" => {:name => "Czech Republic", :special_case => false, :country_name_2_letters => "CZ", :country_name_3_letters => "CZE", :min_cns => 4, :max_cns => 8},
  "421" => {:name => "Slovakia", :special_case => false, :country_name_2_letters => "SK", :country_name_3_letters => "SVK", :min_cns => 4, :max_cns => 10},
  "423" => {:name => "Liechtenstein", :special_case => false, :country_name_2_letters => "LI", :country_name_3_letters => "LIE", :min_cns => 4, :max_cns => 8},
  "500" => {:name => "Falkland Islands", :special_case => false, :country_name_2_letters => "FK", :country_name_3_letters => "FLK", :min_cns => 4, :max_cns => 5},
  "501" => {:name => "Belize", :special_case => false, :country_name_2_letters => "BZ", :country_name_3_letters => "BLZ", :min_cns => 4, :max_cns => 7},
  "502" => {:name => "Guatemala", :special_case => false, :country_name_2_letters => "GT", :country_name_3_letters => "GTM", :min_cns => 4, :max_cns => 7},
  "503" => {:name => "El Salvador", :special_case => false, :country_name_2_letters => "SV", :country_name_3_letters => "SLV", :min_cns => 5, :max_cns => 7},
  "504" => {:name => "Honduras", :special_case => false, :country_name_2_letters => "HN", :country_name_3_letters => "HND", :min_cns => 4, :max_cns => 10},
  "505" => {:name => "Nicaragua", :special_case => false, :country_name_2_letters => "NI", :country_name_3_letters => "NIC", :min_cns => 4, :max_cns => 5},
  "506" => {:name => "Costa Rica", :special_case => false, :country_name_2_letters => "CR", :country_name_3_letters => "CRI", :min_cns => 4, :max_cns => 5},
  "507" => {:name => "Panama", :special_case => false, :country_name_2_letters => "PA", :country_name_3_letters => "PAN", :min_cns => 4, :max_cns => 7},
  "508" => {:name => "Saint Pierre and Miquelon", :special_case => false, :country_name_2_letters => "PM", :country_name_3_letters => "SPM", :min_cns => 5, :max_cns => 5},
  "509" => {:name => "Haiti", :special_case => false, :country_name_2_letters => "HT", :country_name_3_letters => "HTI", :min_cns => 4, :max_cns => 7},
  "590" => {:name => "Guadeloupe", :special_case => false, :country_name_2_letters => "GP", :country_name_3_letters => "GLP", :min_cns => 6, :max_cns => 8},
  "591" => {:name => "Bolivia", :special_case => false, :country_name_2_letters => "BO", :country_name_3_letters => "BOL", :min_cns => 4, :max_cns => 7},
  "592" => {:name => "Guyana", :special_case => false, :country_name_2_letters => "GY", :country_name_3_letters => "GUY", :min_cns => 5, :max_cns => 7},
  "593" => {:name => "Ecuador", :special_case => false, :country_name_2_letters => "EC", :country_name_3_letters => "ECU", :min_cns => 4, :max_cns => 10},
  "594" => {:name => "French Guiana", :special_case => false, :country_name_2_letters => "GF", :country_name_3_letters => "GUF", :min_cns => 6, :max_cns => 8},
  "595" => {:name => "Paraguay", :special_case => false, :country_name_2_letters => "PY", :country_name_3_letters => "PRY", :min_cns => 5, :max_cns => 8},
  "596" => {:name => "Martinique", :special_case => false, :country_name_2_letters => "MQ", :country_name_3_letters => "MTQ", :min_cns => 6, :max_cns => 8},
  "597" => {:name => "Suriname", :special_case => false, :country_name_2_letters => "SR", :country_name_3_letters => "SUR", :min_cns => 4, :max_cns => 6},
  "598" => {:name => "Uruguay", :special_case => false, :country_name_2_letters => "UY", :country_name_3_letters => "URY", :min_cns => 4, :max_cns => 6},
  "599" => {:name => "Netherlands Antilles", :special_case => false, :country_name_2_letters => "AN", :country_name_3_letters => "ANT", :min_cns => 4, :max_cns => 7},
  "670" => {:name => "Timor-Leste", :special_case => false, :country_name_2_letters => "TL", :country_name_3_letters => "TLS", :min_cns => 4, :max_cns => 10},
  "672" => {:name => "Norfolk Island", :special_case => false, :country_name_2_letters => "NF", :country_name_3_letters => "NFK", :min_cns => 4, :max_cns => 5},
  "673" => {:name => "Brunei Darussalam", :special_case => false, :country_name_2_letters => "BN", :country_name_3_letters => "BRN", :min_cns => 4, :max_cns => 6},
  "674" => {:name => "Nauru", :special_case => false, :country_name_2_letters => "NR", :country_name_3_letters => "NRU", :min_cns => 6, :max_cns => 8},
  "675" => {:name => "Papua New Guinea", :special_case => false, :country_name_2_letters => "PG", :country_name_3_letters => "PNG", :min_cns => 5, :max_cns => 10},
  "676" => {:name => "Tonga", :special_case => false, :country_name_2_letters => "TO", :country_name_3_letters => "TON", :min_cns => 5, :max_cns => 6},
  "677" => {:name => "Solomon Islands", :special_case => false, :country_name_2_letters => "SB", :country_name_3_letters => "SLB", :min_cns => 4, :max_cns => 7},
  "678" => {:name => "Vanuatu", :special_case => false, :country_name_2_letters => "VU", :country_name_3_letters => "VUT", :min_cns => 5, :max_cns => 7},
  "679" => {:name => "Fiji", :special_case => false, :country_name_2_letters => "FJ", :country_name_3_letters => "FJI", :min_cns => 5, :max_cns => 5},
  "680" => {:name => "Palau", :special_case => false, :country_name_2_letters => "PW", :country_name_3_letters => "PLW", :min_cns => 6, :max_cns => 6},
  "681" => {:name => "Wallis and Futuna Islands", :special_case => false, :country_name_2_letters => "WF", :country_name_3_letters => "WLF", :min_cns => 4, :max_cns => 5},
  "682" => {:name => "Cook Islands", :special_case => false, :country_name_2_letters => "CK", :country_name_3_letters => "COK", :min_cns => 4, :max_cns => 5},
  "683" => {:name => "Niue", :special_case => false, :country_name_2_letters => "NU", :country_name_3_letters => "NIU", :min_cns => 4, :max_cns => 4},
  "685" => {:name => "Samoa", :special_case => false, :country_name_2_letters => "WS", :country_name_3_letters => "WSM", :min_cns => 4, :max_cns => 6},
  "686" => {:name => "Kiribati", :special_case => false, :country_name_2_letters => "KI", :country_name_3_letters => "KIR", :min_cns => 4, :max_cns => 5},
  "687" => {:name => "New Caledonia", :special_case => false, :country_name_2_letters => "NC", :country_name_3_letters => "NCL", :min_cns => 5, :max_cns => 5},
  "688" => {:name => "Tuvalu", :special_case => false, :country_name_2_letters => "TV", :country_name_3_letters => "TUV", :min_cns => 4, :max_cns => 6},
  "689" => {:name => "French Polynesia", :special_case => false, :country_name_2_letters => "PF", :country_name_3_letters => "PYF", :min_cns => 4, :max_cns => 7},
  "690" => {:name => "Tokelau", :special_case => false, :country_name_2_letters => "TK", :country_name_3_letters => "TKL", :min_cns => 4, :max_cns => 4},
  "691" => {:name => "Micronesia", :special_case => false, :country_name_2_letters => "FM", :country_name_3_letters => "FSM", :min_cns => 6, :max_cns => 7},
  "692" => {:name => "Marshall Islands", :special_case => false, :country_name_2_letters => "MH", :country_name_3_letters => "MHL", :min_cns => 6, :max_cns => 6},
  "699" => {:name => "United States Minor Outlying Islands", :special_case => false, :country_name_2_letters => "UM", :country_name_3_letters => "UMI", :min_cns => 4, :max_cns => 4},
  "800" => {:name => "International Freephone Service", :special_case => false, :country_name_2_letters => "XT", :country_name_3_letters => "", :min_cns => 1000, :max_cns => 0},
  "808" => {:name => "International Shared Cost Service", :special_case => false, :country_name_2_letters => "XS", :country_name_3_letters => "", :min_cns => 1000, :max_cns => 0},
  "850" => {:name => "Korea; North", :special_case => false, :country_name_2_letters => "KP", :country_name_3_letters => "PRK", :min_cns => 4, :max_cns => 7},
  "852" => {:name => "Hong Kong", :special_case => false, :country_name_2_letters => "HK", :country_name_3_letters => "HKG", :min_cns => 4, :max_cns => 9},
  "853" => {:name => "Macau", :special_case => false, :country_name_2_letters => "MO", :country_name_3_letters => "MAC", :min_cns => 4, :max_cns => 11},
  "855" => {:name => "Cambodia", :special_case => false, :country_name_2_letters => "KH", :country_name_3_letters => "KHM", :min_cns => 5, :max_cns => 8},
  "856" => {:name => "Laos", :special_case => false, :country_name_2_letters => "LA", :country_name_3_letters => "LAO", :min_cns => 5, :max_cns => 8},
  "870" => {:name => "International Satellite Service", :special_case => false, :country_name_2_letters => "XN", :country_name_3_letters => "", :min_cns => 4, :max_cns => 5},
  "872" => {:name => "Pitcairn Islands", :special_case => false, :country_name_2_letters => "PN", :country_name_3_letters => "PCN", :min_cns => 11, :max_cns => 12},
  "878" => {:name => "Universal Personal Telecommunication Service", :special_case => false, :country_name_2_letters => "XP", :country_name_3_letters => "", :min_cns => 5, :max_cns => 5},
  "880" => {:name => "Bangladesh", :special_case => false, :country_name_2_letters => "BD", :country_name_3_letters => "BGD", :min_cns => 4, :max_cns => 9},
  "881" => {:name => "Global Mobile Satellite System", :special_case => false, :country_name_2_letters => "XG", :country_name_3_letters => "", :min_cns => 4, :max_cns => 4},
  "882" => {:name => "International Networks", :special_case => false, :country_name_2_letters => "XV", :country_name_3_letters => "", :min_cns => 5, :max_cns => 7},
  "883" => {:name => "International National Rate Service", :special_case => false, :country_name_2_letters => "XL", :country_name_3_letters => "", :min_cns => 6, :max_cns => 7},
  "888" => {:name => "United Nations Office for the Coordination of Humanitarian Affairs", :special_case => false, :country_name_2_letters => "XH", :country_name_3_letters => "", :min_cns => 1000, :max_cns => 3},
  "960" => {:name => "Maldives", :special_case => false, :country_name_2_letters => "MV", :country_name_3_letters => "MDV", :min_cns => 4, :max_cns => 6},
  "961" => {:name => "Lebanon", :special_case => false, :country_name_2_letters => "LB", :country_name_3_letters => "LBN", :min_cns => 4, :max_cns => 5},
  "962" => {:name => "Jordan", :special_case => false, :country_name_2_letters => "JO", :country_name_3_letters => "JOR", :min_cns => 4, :max_cns => 8},
  "963" => {:name => "Syria", :special_case => false, :country_name_2_letters => "SY", :country_name_3_letters => "SYR", :min_cns => 5, :max_cns => 11},
  "964" => {:name => "Iraq", :special_case => false, :country_name_2_letters => "IQ", :country_name_3_letters => "IRQ", :min_cns => 4, :max_cns => 7},
  "965" => {:name => "Kuwait", :special_case => false, :country_name_2_letters => "KW", :country_name_3_letters => "KWT", :min_cns => 4, :max_cns => 10},
  "966" => {:name => "Saudi Arabia", :special_case => false, :country_name_2_letters => "SA", :country_name_3_letters => "SAU", :min_cns => 4, :max_cns => 12},
  "967" => {:name => "Yemen", :special_case => false, :country_name_2_letters => "YE", :country_name_3_letters => "YEM", :min_cns => 4, :max_cns => 7},
  "968" => {:name => "Oman", :special_case => false, :country_name_2_letters => "OM", :country_name_3_letters => "OMN", :min_cns => 5, :max_cns => 8},
  "970" => {:name => "Palestine", :special_case => false, :country_name_2_letters => "PS", :country_name_3_letters => "PSE", :min_cns => 4, :max_cns => 7},
  "971" => {:name => "United Arab Emirates", :special_case => false, :country_name_2_letters => "AE", :country_name_3_letters => "ARE", :min_cns => 4, :max_cns => 9},
  "972" => {:name => "Israel", :special_case => false, :country_name_2_letters => "IL", :country_name_3_letters => "ISR", :min_cns => 4, :max_cns => 8},
  "973" => {:name => "Bahrain", :special_case => false, :country_name_2_letters => "BH", :country_name_3_letters => "BHR", :min_cns => 4, :max_cns => 6},
  "974" => {:name => "Qatar", :special_case => false, :country_name_2_letters => "QA", :country_name_3_letters => "QAT", :min_cns => 4, :max_cns => 10},
  "975" => {:name => "Bhutan", :special_case => false, :country_name_2_letters => "BT", :country_name_3_letters => "BTN", :min_cns => 4, :max_cns => 9},
  "976" => {:name => "Mongolia", :special_case => false, :country_name_2_letters => "MN", :country_name_3_letters => "MNG", :min_cns => 5, :max_cns => 8},
  "977" => {:name => "Nepal", :special_case => false, :country_name_2_letters => "NP", :country_name_3_letters => "NPL", :min_cns => 4, :max_cns => 9},
  "979" => {:name => "International Premium Rate Service", :special_case => false, :country_name_2_letters => "XR", :country_name_3_letters => "", :min_cns => 4, :max_cns => 4},
  "991" => {:name => "International Public Correspondence Service", :special_case => false, :country_name_2_letters => "XC", :country_name_3_letters => "", :min_cns => 1000, :max_cns => 0},
  "992" => {:name => "Tajikistan", :special_case => false, :country_name_2_letters => "TJ", :country_name_3_letters => "TJK", :min_cns => 4, :max_cns => 10},
  "993" => {:name => "Turkmenistan", :special_case => false, :country_name_2_letters => "TM", :country_name_3_letters => "TKM", :min_cns => 4, :max_cns => 6},
  "994" => {:name => "Azerbaijan", :special_case => false, :country_name_2_letters => "AZ", :country_name_3_letters => "AZE", :min_cns => 5, :max_cns => 8},
  "995" => {:name => "Georgia", :special_case => true, :country_name_2_letters => "GE", :country_name_3_letters => "GEO", :min_cns => 5, :max_cns => 6},
  "996" => {:name => "Kyrgyzstan", :special_case => false, :country_name_2_letters => "KG", :country_name_3_letters => "KGZ", :min_cns => 5, :max_cns => 8},
  "998" => {:name => "Uzbekistan", :special_case => false, :country_name_2_letters => "UZ", :country_name_3_letters => "UZB", :min_cns => 5, :max_cns => 5}
}