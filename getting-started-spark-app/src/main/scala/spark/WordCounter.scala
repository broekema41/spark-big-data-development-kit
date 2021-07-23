package spark

import org.apache.spark.{SparkContext}

object WordCounter {
  def main(sc: SparkContext) {
    println("Word Counter")

    val textFile = sc.textFile("file:///var/www/spark/files/README.md")
    val tokenizedFileData = textFile.flatMap(line => line.split(" "))
    val countPrep = tokenizedFileData.map(word => (word, 1))
    val counts = countPrep.reduceByKey((accumValue, newValue) => accumValue + newValue)
    val sortedCounts = counts.sortBy(kvPair => kvPair._2, ascending = false)
    sortedCounts.saveAsTextFile("file:///var/www/spark/files/ReadMeWordCountViaApp")

  }
}
