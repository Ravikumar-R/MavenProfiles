#!/bin/sh
PASS=0
rm -f .output.txt

mvn clean package | tee .output.txt >/dev/null;

TEST_1=$(grep -io -e "BUILD SUCCESS" .output.txt| wc -l);
TEST_2=$(grep -i '\[echo\]' .output.txt | grep -io -e 'Packaged for environment\s*:\s*DEV' -e 'db.url\s*:\s*jdbc:mysql://localhost:3306/dev' -e 'db.username\s*:\s*devuser' -e 'db.password\s*:\s*devpwd' | wc -l);
TEST_3=$(find target/maven-DEV-profile.jar 2>/dev/null| wc -l );

truncate -s 0 .output.txt;
mvn clean package -Pqa| tee .output.txt >/dev/null;

TEST_4=$(grep -io -e "BUILD SUCCESS" .output.txt| wc -l);
TEST_5=$(grep -i '\[echo\]' .output.txt | grep -io -e 'Packaged for environment\s*:\s*QA' -e 'db.url\s*:\s*jdbc:mysql://serv01:3306/qa' -e 'db.username\s*:\s*qauser' -e 'db.password\s*:\s*qapwd' | wc -l);
TEST_6=$(find target/maven-QA-profile.jar 2>/dev/null| wc -l );

truncate -s 0 .output.txt;
mvn clean package -Pprod| tee .output.txt >/dev/null;

TEST_7=$(grep -io -e "BUILD SUCCESS" .output.txt| wc -l);
TEST_8=$(grep -i '\[echo\]' .output.txt | grep -io -e 'Packaged for environment\s*:\s*PROD' -e 'db.url\s*:\s*jdbc:mysql://live01:3306/prod' -e 'db.username\s*:\s*produser' -e 'db.password\s*:\s*\*\*\*\*\*\*' | wc -l);
TEST_9=$(find target/maven-PROD-profile.jar 2>/dev/null| wc -l );


TEST_10=$(grep -io -e "org.apache.maven.plugins" -e "maven-antrun-plugin" pom.xml | wc -l)
TEST_11=$(grep -io -e "<phase>" -e "<execution>" -e "<goal>" -e "<id>" -e "<goals>" -e "package" pom.xml | wc -l);
TEST_12=$(grep -io -e "<finalName>" -e "maven-\${db.env}-profile" pom.xml | wc -l);
TEST_13=$(grep -io -e "<profiles>" -e "<profile>" -e "<id>" -e "<properties>" -e "<activeByDefault>" -e "<activation>" pom.xml | wc -l);
TEST_14=$(grep -io -e "dev" -e "qa" -e "prod" pom.xml | wc -l);
TEST_15=$(grep -io -e "<db.env>" -e "<db.url>" -e "<db.username>" -e "<db.password>" pom.xml | wc -l);

echo "TEST_1=$TEST_1";
echo "TEST_2=$TEST_2";
echo "TEST_3=$TEST_3";
echo "TEST_4=$TEST_4";
echo "TEST_5=$TEST_5";
echo "TEST_6=$TEST_6";
echo "TEST_7=$TEST_7";
echo "TEST_8=$TEST_8";
echo "TEST_9=$TEST_9";
echo "TEST_10=$TEST_10";
echo "TEST_11=$TEST_11";
echo "TEST_12=$TEST_12";
echo "TEST_13=$TEST_13";
echo "TEST_14=$TEST_14";
echo "TEST_15=$TEST_15";


if [ "$TEST_1" -gt 0 ]
then PASS=$((PASS + 5))
fi;
if [ "$TEST_2" -gt 3 ]
then PASS=$((PASS + 10))
fi;
if [ "$TEST_3" -gt 0 ]
then PASS=$((PASS + 10))
fi;
if [ "$TEST_4" -gt 0 ]
then PASS=$((PASS + 5))
fi;
if [ "$TEST_5" -gt 3 ]
then PASS=$((PASS + 10))
fi;
if [ "$TEST_6" -gt 0 ]
then PASS=$((PASS + 10))
fi;
if [ "$TEST_7" -gt 0 ]
then PASS=$((PASS + 5))
fi;
if [ "$TEST_8" -gt 3 ]
then PASS=$((PASS + 10))
fi;
if [ "$TEST_9" -gt 0 ]
then PASS=$((PASS + 10))
fi;
if [ "$TEST_10" -gt 1 ]
then PASS=$((PASS + 2))
fi;
if [ "$TEST_11" -gt 5 ]
then PASS=$((PASS + 5))
fi;
if [ "$TEST_12" -gt 1 ]
then PASS=$((PASS + 5))
fi;
if [ "$TEST_13" -gt 5 ]
then PASS=$((PASS + 5))
fi;
if [ "$TEST_14" -gt 2 ]
then PASS=$((PASS + 5))
fi;
if [ "$TEST_15" -gt 3 ]
then PASS=$((PASS + 3))
fi;

echo "FS_SCORE:$PASS%" 
