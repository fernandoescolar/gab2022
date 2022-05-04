docker build sln -t myapi:0.1 .
docker run -p 8080:80 --rm myapi
curl http://localhost:8080/WeatherForecast
