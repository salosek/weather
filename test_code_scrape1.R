## Not run: 
## This changed to using https: in June 2015, and that is unsupported.
# u = "http://en.wikipedia.org/wiki/World_population"
u <- scrape("https://en.wikipedia.org/wiki/List_of_countries_and_dependencies_by_population")

testparse <- htmlParse(u)
tables <- readHTMLTable(u, stringsAsFactors=FALSE)
names(tables)

tables[[2]]
# Print the table. Note that the values are all characters
# not numbers. Also the column names have a preceding X since
# R doesn't allow the variable names to start with digits.
tmp = tables[[2]]


# Let's just read the second table directly by itself.
doc = htmlParse(u)
tableNodes = getNodeSet(doc, "//table")
tb = readHTMLTable(tableNodes[[2]])

# Let's try to adapt the values on the fly.
# We'll create a function that turns a th/td node into a val
tryAsInteger = function(node) {
  val = xmlValue(node)
  ans = as.integer(gsub(",", "", val))
  if(is.na(ans))
    val
  else
    ans
}

tb = readHTMLTable(tableNodes[[2]], elFun = tryAsInteger)

tb = readHTMLTable(tableNodes[[2]], elFun = tryAsInteger,
                   colClasses = c("character", rep("integer", 9)))

## End(Not run)
