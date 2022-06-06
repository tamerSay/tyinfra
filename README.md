# tyinfra

To Build <br>
> docker build -t tyinfra -f Dockerfile .

To Run <br>
> docker run -p8080:80 -p443:443  -d tyinfra
<br><br>
Note <br>
> 172.17.0.1 tyinfra.com www.tyinfra.com

*172.17.0.1* is the IP address of the docker interface in local machine.
<br>
In order to access the web address www.tyinfra.com, corresponding IP of the build or running environment must be added to **hosts** file.
