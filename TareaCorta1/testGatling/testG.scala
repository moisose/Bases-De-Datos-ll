/*
testG.scala

gatling-charts-highcharts-bundle-3.9.2/users-files/simulation

Import of libs
*/
import io.gatling.core.Predef._
import io.gatling.http.Predef._
import scala.concurrent.duration._

/*
Class testDataset
*/
class testDataset extends Simulation {
  /*define http dir*/
  val httpConf = http.baseUrl("http://127.0.0.1:5000")
  /*define scenario*/
  val scn = scenario("escenario")
    .exec(http("peticion")
      .post("/babynames")
      .check(status.is(200)) /*Verifies status equals 200*/
    )
  /*Users per second*/
  setUp(
    scn.inject(constantUsersPerSec(5) during (30 seconds))
  ).protocols(httpConf)
}