#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

VALID_ARG=0

if [[ -z $1 ]]
then
    echo "Please provide an element as an argument."
    exit
else
    ARG=$1
fi
#DELETE COLUMN TYPE:
#$PSQL "ALTER TABLE properties DROP COLUMN type"
#DELETE ROW WITH ATOMIC NUMBER =1000 FROM TABLES
#$PSQL "DELETE FROM properties WHERE atomic_number=1000"
#$PSQL "DELETE FROM elements WHERE atomic_number=1000"

#ADD 2 NEW ELEMENTS TO THE TABLES ELEMENTS AND PROPERTIES:
CHECK_ATOMIC_NUMBER_9_ELEMENTS=$($PSQL " SELECT atomic_number FROM elements WHERE atomic_number = 9 " );
CHECK_ATOMIC_NUMBER_10_ELEMENTS=$($PSQL " SELECT atomic_number FROM elements WHERE atomic_number = 10 " );
CHECK_ATOMIC_NUMBER_9_PROPERTIES=$($PSQL " SELECT atomic_number FROM properties WHERE atomic_number = 9 " );
CHECK_ATOMIC_NUMBER_10_PROPERTIES=$($PSQL " SELECT atomic_number FROM properties WHERE atomic_number = 10 " );
if [[ ! $CHECK_ATOMIC_NUMBER_9_ELEMENTS ]]
then
    $PSQL "INSERT INTO elements(atomic_number, symbol, name) VALUES(9, 'F', 'Fluorine')";
fi
if [[ ! $CHECK_ATOMIC_NUMBER_10_ELEMENTS ]]
then
    $PSQL "INSERT INTO elements(atomic_number, symbol, name) VALUES(10, 'Ne', 'Neon')";
fi
if [[ ! $CHECK_ATOMIC_NUMBER_9_PROPERTIES ]]
then
    $PSQL "INSERT INTO properties(atomic_number, atomic_mass, melting_point_celsius, boiling_point_celsius, type_id) VALUES(9, 18.998, -220, -188.1, 1)";
fi
if [[ ! $CHECK_ATOMIC_NUMBER_10_PROPERTIES ]]
then
    $PSQL "INSERT INTO properties(atomic_number, atomic_mass, melting_point_celsius, boiling_point_celsius, type_id) VALUES(10, 20.18, -248.6, -246.1, 1)";
fi


if [[ $ARG =~ ^[1-9]0?$ ]]
then
    DATA=$($PSQL " SELECT * FROM elements INNER JOIN properties USING (atomic_number) WHERE atomic_number = $ARG " );
    TYPE=$($PSQL " SELECT type FROM types INNER JOIN properties USING (type_id) WHERE atomic_number = $ARG " );
else
    DATA=$($PSQL " SELECT * FROM elements INNER JOIN properties USING (atomic_number) WHERE symbol = '$ARG' OR name = '$ARG' ");
    TYPE=$($PSQL " SELECT type FROM types INNER JOIN properties USING (type_id) INNER JOIN elements USING (atomic_number) WHERE symbol = '$ARG' OR name = '$ARG' ");
fi



if [[ -z $DATA ]]
then
    echo "I could not find that element in the database."
    exit
else
    echo $DATA | while read ATOMIC_NUMBER BAR SYMBOL BAR NAME BAR MASS BAR MELTING BAR BOILING BAR TYPE_ID
    do
      echo -e "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a$TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
    done  

fi

#echo $DATA | while IFS=" |" read ATOMIC_NUMBER TYPE MASS MELTING_POINT BOILING_POINT SYMBOL NAME


