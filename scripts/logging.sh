write_log4j2() {
cat << EOF > $SERVER_PATH/log4j2.xml
<?xml version="1.0" encoding="UTF-8"?>
<Configuration status="WARN" packages="com.mojang.util">
    <Appenders>
        <Console name="SysOut" target="SYSTEM_OUT">
            <PatternLayout pattern="[%d{HH:mm:ss}] [%t/%level]: %msg%n" />
        </Console>
        <RollingRandomAccessFile name="File" fileName="logs/latest.log" filePattern="logs/%d{yyyy-MM-dd}-%i.log">
            <PatternLayout pattern="[%d{yyyy/MM/dd HH:mm:ss}] [%t/%level]: %msg%n" />
            <Policies>
                <TimeBasedTriggeringPolicy />
            </Policies>
            <DefaultRolloverStrategy>
                <Delete basePath="logs">
                    <IfFileName glob="*.log" />
                    <IfLastModified age="7d" />
                </Delete>
            </DefaultRolloverStrategy>
        </RollingRandomAccessFile>
    </Appenders>
    <Loggers>
        <Root level="info">
            <filters>
                <MarkerFilter marker="NETWORK_PACKETS" onMatch="DENY" onMismatch="NEUTRAL" />
            </filters>
            <AppenderRef ref="SysOut"/>
            <AppenderRef ref="File"/>
        </Root>
    </Loggers>
</Configuration>
EOF
}

configure_logging(){
  write_log4j2
  JVM_OPTS="-Dlog4j.configurationFile=${SERVER_PATH}/log4j2.xml ${JVM_OPTS}"
}