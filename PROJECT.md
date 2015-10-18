Sometimes it's needed to generate fingerprints of files (a.k.a. MD5-checksums) on the clientside, maybe to check if the files that
been uploaded to the server are really the same...every single bit of it. I also used this technique in another application,
where the user generated metadata of files inside the application. As this application is running offline, I needed to store the
data inside the browser (HTML5-localstorage) and decided that it's best to use a fingerprint as my key for localstorage...
this way I've been able to load previously generated metadata as soon as the user has loaded a file inside the app.

This module is always splitting the files into chunks of 2MB before generating the fingerprint, as otherwise
it would consume WAY too much memory, leading to wrong fingerprints when large files are selected. Another advantage of this technique
is the fact that it's just faster than leaving the files as is...plus we can show a progress while calculating the fingerprints in
the background ;-)
