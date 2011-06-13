resolvers += "less is" at "http://repo.lessis.me"

libraryDependencies ++= Seq(
   "org.jcoffeescript" % "jcoffeescript" % "1.1" from 
     "http://cloud.github.com/downloads/yeungda/jcoffeescript/jcoffeescript-1.0.jar",
   "me.lessis" %% "coffeescripted-sbt" % "0.1.1"
)