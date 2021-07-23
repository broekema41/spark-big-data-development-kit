name := "spark"

version := "0.1"

scalaVersion := "2.11.12"

libraryDependencies += "org.apache.spark" % "spark-core_2.11" % "2.4.6" % "provided"
libraryDependencies += "org.apache.spark" % "spark-sql_2.11" % "2.4.6" % "provided"


artifactName := { (sv: ScalaVersion, module: ModuleID, artifact: Artifact) =>
  "spark.jar"
}
