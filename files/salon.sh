#! /bin/bash

PSQL="psql --username=freecodecamp --dbname=salon --no-align --tuples-only -c"

echo -e "\n~~~~~ MY SALON ~~~~~\n"
echo -e "Welcome to My Salon, how can I help you?\n"

MAIN_MENU () {
  if [[ ! -z $1 ]]
  then
    echo -e "\n$1"
  fi
  echo -e "1) cut\n2) color\n3) perm\n4) style\n5) trim"
  read SERVICE_ID_SELECTED

  case $SERVICE_ID_SELECTED in
    1) SERVICE_FUN "cut";;
    2) SERVICE_FUN "color";;
    3) SERVICE_FUN "perm";;
    4) SERVICE_FUN "style";;
    5) SERVICE_FUN "trim";;
    *) MAIN_MENU "PICK a service from the list";;
  esac
}

SERVICE_FUN () {
  if [[ ! -z $1 ]]
  then
    SERVICE_ID_SELECTED=$($PSQL "SELECT service_id FROM services WHERE name = '$1'")
  fi
  
  echo -e "\nWhat's your phone number?"
  read CUSTOMER_PHONE

  # Check if phone number exists in the customers table
  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")
  if [[ -z $CUSTOMER_ID ]]
  # if customer doesn't exits
  then
    echo -e "\nI don't have a record for that phone number, what's your name?"
    read CUSTOMER_NAME
    CUSTOMER_INSERTION=$($PSQL "INSERT INTO customers (phone, name) VALUES ('$CUSTOMER_PHONE', '$CUSTOMER_NAME')")
  else
    CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")
  fi
  # get customer id
  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")

  # get the oppointment time
  echo -e "\nWhat time would you like your cut, $CUSTOMER_NAME?"
  read SERVICE_TIME

  # add the appointment to the table
  APPOINTMEN_INSERTION=$($PSQL "INSERT INTO appointments (customer_id, service_id, time) VALUES ($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")

  if [[ $APPOINTMEN_INSERTION == "INSERT 0 1" ]]
  then
    echo "I have put you down for a $1 at $SERVICE_TIME, $CUSTOMER_NAME."
  fi
}

MAIN_MENU