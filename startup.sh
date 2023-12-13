apt-get update
apt-get install -y docker.io
systemctl start docker
echo "<html><head><title>Titolo pagina esercizio</title></head><body><h1>Giacomo Quaglia Esercizio 002 - $1</h1></body></html>" >index.html
docker run -d -p 80:80 --name test -v "$PWD/index.html:/usr/share/nginx/html/index.html" nginx