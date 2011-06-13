package meetelf

import unfiltered.request._
import unfiltered.response._

object Server {
  def main(args: Array[String]) {
    unfiltered.jetty.Http(8080).resources(
      new java.net.URL(getClass.getResource("/webroot/marker"), ".")
    ).run()
  }
}
