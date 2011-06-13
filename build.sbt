libraryDependencies ++= Seq(
  "net.databinder" %% "unfiltered-filter" % "0.3.3",
  "net.databinder" %% "unfiltered-jetty" % "0.3.3"
)

coffeeTarget <<= (resourceManaged in Compile) { d => d }