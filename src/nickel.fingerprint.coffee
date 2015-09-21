#
# Generating MD5-Fingerprints of files, using SparkMD5-Library
#
# @author   Alexander Nickel <mr.alexander.nickel@gmail.com>
# @param    file the file to generate checksum from...JS-File-Object
# @return   promise
#
FingerprintProvider = ($q) ->
  # SIZE OF SINGLE CHUNK
  CHUNK_SIZE = 2097152
  
  # DEFINE SLICE CONSTRUCTOR DEPENDING ON BROWSER
  SLICE = Blob::slice or Blob::mozSlice or Blob::webkitSlice

  # GENERATE THE FINGERPRINT
  @generate = (file) ->
    deferred = $q.defer()
    loadNext = ->
      fileReader = new FileReader()
      fileReader.onload = frOnload
      fileReader.onerror = frOnerror
      start = currentChunk * CHUNK_SIZE
      end = if start + CHUNK_SIZE >= file.size then file.size else start + CHUNK_SIZE
      fileReader.readAsArrayBuffer SLICE.call(file, start, end)
    chunks = Math.ceil(file.size / CHUNK_SIZE)
    chunkPercentage = Math.ceil(100 / chunks)
    currentChunk = 0
    spark = new SparkMD5.ArrayBuffer()
    frOnload = (e) ->
      spark.append e.target.result
      currentChunk++
      if currentChunk < chunks
        loadNext()
        deferred.notify currentChunk * chunkPercentage
      else
        deferred.resolve filename: file.name fingerprint: spark.end()
    frOnerror = ->
      deferred.reject "ERROR"
    loadNext()
    return deferred.promise

  # SIMPLY PREVENT COFFEESCRIPT FROM RETURNING @generate
  return

# DEFINE ANGULAR MODULE
angular.module "nickel.fingerprint", []
       .service "$fingerprint", FingerprintProvider
