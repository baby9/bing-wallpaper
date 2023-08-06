addEventListener('fetch', event => {
  event.respondWith(handleRequest(event.request));
});

async function handleRequest(request) {
  // 设置请求头
  const headers = {
    'Accept-Language': 'en-US,en;q=0.9',
    'User-Agent': `Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/100.0.4896.127 Safari/537.36`,
  };

  // 获取图片 URL
  const response = await fetch('https://www.bing.com/HPImageArchive.aspx?format=js&idx=0&n=1&mkt=en-US', { headers });
  const data = await response.json();
  const imageUrl = `https://www.bing.com${data.images[0].url}`;

  // 执行重定向操作
  return Response.redirect(imageUrl, 301);
}
