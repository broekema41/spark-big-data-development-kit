import org.apache.spark.{SparkConf, SparkContext}

object Main {
  def main(args: Array[String]): Unit = {
    println("started")
    val basePath = "/var/www/spark-big-data-development-kit/getting-started-spark-app/"
    val conf = new SparkConf()
      // host access from inside the vagrant and pods is on this ip address
      .setMaster("spark://172.28.127.137:7077")
      // application name to be used in sparkUi
      .setAppName("Example program")
    val sc = new SparkContext(conf)
    sc.addJar(basePath + "dags/spark.jar")
    spark.WordCounter.main(sc, basePath)
  }
}

