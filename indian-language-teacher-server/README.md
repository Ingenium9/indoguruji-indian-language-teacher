Make sure you have Python installed, based on which python you have you may need to change

`py with python/python3`

Instructions for Windows OS:

Clone this repo:

```
git clone https://github.com/veermetri05/indian-language-teacher-server.git
```

Navigate to folder:

```
cd indian-language-teacher-server
```

First create a virtual environment:

```
py -m venv env
```

Activate the virtual environment

```
./env/Scripts/activate
```

Install the dependencies with:

```
pip install -r requirements.txt
```

Set the environment variable for the location of file (change the path) :

```
$env:GOOGLE_APPLICATION_CREDENTIALS="C:\Users\username\Downloads\ILTKey.json"
```

Navigate to ILT folder:

```
cd ILT
```

Start the server by running the following command:

```
py manage.py runserver
```

Or with local IP address such as 192.168.1.3:8000

```
py manage.py runserver 192.168.1.3:8000
```