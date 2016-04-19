all: target/TPCH_Tools.zip target/tpch_2_17_0/dbgen/dbgen target/target/lib/dbgen.jar target/target/tpch-gen-1.0-SNAPSHOT.jar

target/TPCH_Tools.zip:
	echo "Download TPCH_Tools.zip and place into the target directory"
	false

target/target/tpch-gen-1.0-SNAPSHOT.jar: $(shell find ./ -name *.java)
	( cd target && mvn package )

target/target/lib/dbgen.jar: target/tpch_2_17_0/dbgen/dbgen
	( cd target/tpch_2_17_0 && mkdir -p ../target/lib ; ( jar cvf ../target/lib/dbgen.jar dbgen/ || gjar cvf ../target/lib/dbgen.jar dbgen/ ) )

target/tpch_2_17_0/dbgen/dbgen:
	( cd target && unzip -o TPCH_Tools.zip )
	( cd target/tpch_2_17_0/dbgen && make -f makefile.suite clean; make -f makefile.suite CC=gcc DATABASE=ORACLE MACHINE=LINUX WORKLOAD=TPCH )

clean:
	(cd target/tpch_2_17_0/dbgen && make -f makefile.suite clean)
	(cd target ; mvn clean)
