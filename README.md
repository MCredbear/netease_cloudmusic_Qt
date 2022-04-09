# netease_cloudmusic_Qt
一个基于Qt的网易云客户端  
AES: https://github.com/bricke/Qt-AES  
RSA: OpenSSL  
API: https://github.com/binaryify/NeteaseCloudMusicApi  
状态栏: https://github.com/jpnurmi/statusbar  

由于Qt在安卓下过于拉胯，移动端转进Flutter力  
所以现在这个只做桌面端UI

由于Qt下RSA依赖OpenSSL，会导致项目难以构建，所以现在改用linuxapi
