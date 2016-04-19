all: target/TPCDS_Tools.zip target/v1.4.0/tools/dsdgen target/target/lib/dsdgen.jar target/target/tpcds-gen-1.0-SNAPSHOT.jar

target/TPCDS_Tools.zip:
	echo "Download TPCDS_Tools.zip and place into the target directory"
	false

target/target/tpcds-gen-1.0-SNAPSHOT.jar: $(shell find ./ -name *.java)
	( cd target && mvn package )

target/target/lib/dsdgen.jar: target/v1.4.0/tools/dsdgen
	( cd target/v1.4.0 && mkdir -p ../target/lib ; ( jar cvf ../target/lib/dsdgen.jar tools/ || gjar cvf ../target/lib/dsdgen.jar tools/ ) )

target/v1.4.0/tools/dsdgen:
	( cd target && unzip -o TPCDS_Tools.zip )
	( cd target/v1.4.0/tools && cat ../../../patches/*.patch | patch -p0 )
	( cd target/v1.4.0/tools && make clean; make dsdgen )

clean:
	(cd target/v1.4.0/tools ; make clean)
	(cd target ; mvn clean)
