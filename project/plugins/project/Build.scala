import sbt._
object PluginDef extends Build {
  lazy val root = Project("plugins", file(".")) dependsOn( webPlugin )
  lazy val webPlugin = uri("../../../coffeescripted-sbt")
}
