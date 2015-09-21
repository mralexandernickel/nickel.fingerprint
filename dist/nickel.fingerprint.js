(function() {
  var FingerprintProvider;

  FingerprintProvider = function($q) {
    var CHUNK_SIZE, SLICE;
    CHUNK_SIZE = 2097152;
    SLICE = Blob.prototype.slice || Blob.prototype.mozSlice || Blob.prototype.webkitSlice;
    this.generate = function(file) {
      var chunkPercentage, chunks, currentChunk, deferred, frOnerror, frOnload, loadNext, spark;
      deferred = $q.defer();
      loadNext = function() {
        var end, fileReader, start;
        fileReader = new FileReader();
        fileReader.onload = frOnload;
        fileReader.onerror = frOnerror;
        start = currentChunk * CHUNK_SIZE;
        end = start + CHUNK_SIZE >= file.size ? file.size : start + CHUNK_SIZE;
        return fileReader.readAsArrayBuffer(SLICE.call(file, start, end));
      };
      chunks = Math.ceil(file.size / CHUNK_SIZE);
      chunkPercentage = Math.ceil(100 / chunks);
      currentChunk = 0;
      spark = new SparkMD5.ArrayBuffer();
      frOnload = function(e) {
        var result;
        spark.append(e.target.result);
        currentChunk++;
        if (currentChunk < chunks) {
          loadNext();
          return deferred.notify(currentChunk * chunkPercentage);
        } else {
          result = {};
          result[file.name] = spark.end();
          return deferred.resolve(result);
        }
      };
      frOnerror = function() {
        return deferred.reject("ERROR");
      };
      loadNext();
      return deferred.promise;
    };
  };

  angular.module("nickel.fingerprint", []).service("$fingerprint", FingerprintProvider);

}).call(this);
