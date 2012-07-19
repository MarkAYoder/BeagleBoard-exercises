function show(res) {
  var html = 'h1'       
    + 'ul'
    + 'form method="post" action="/"';
  res.setHeader('Content-Type', 'text/html');
  res.setHeader('Content-Length', Buffer.byteLength(html));
  res.end(html);
}