name := """hackday-sharx"""

version := "1.0-SNAPSHOT"

lazy val myProject = (project in file(".")).enablePlugins(PlayJava, PlayEbean)

scalaVersion := "2.11.6"

libraryDependencies ++= Seq(
  javaJdbc,
  cache,
  javaWs
)

// Play provides two styles of routers, one expects its actions to be injected, the
// other, legacy style, accesses its actions statically.
routesGenerator := InjectedRoutesGenerator

TaskKey[Unit]("stop") := {
  val pidFile = target.value / "universal" / "stage" / "RUNNING_PID"
  if (!pidFile.exists) throw new Exception("App not started!")
  val pid = IO.read(pidFile)
  s"kill $pid".!
  println(s"Stopped application with process ID $pid")
}
