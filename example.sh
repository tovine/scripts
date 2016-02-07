# Example script for starting or connecting to an application instance that should only run once...

APP_NAME="Application name" 
EXEC_PATH=/path/to/executable

if ! screen -list | grep -q $APP_NAME; then
	screen -mS $APP_NAME $EXEC_PATH
	echo "$APP_NAME not running, started new session..."
else 
	screen -rx $APP_NAME
fi
