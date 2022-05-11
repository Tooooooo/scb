package com.foo.bar;

import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.ArrayUtils;
import org.apache.commons.lang3.StringUtils;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.builder.SpringApplicationBuilder;
import org.springframework.boot.web.servlet.ServletComponentScan;
import org.springframework.context.ConfigurableApplicationContext;
import org.springframework.core.env.ConfigurableEnvironment;

import java.net.InetAddress;
import java.net.UnknownHostException;

@SpringBootApplication(scanBasePackages = "com.foo.bar")
//@EnableCaching
@ServletComponentScan(basePackages = "com.foo.bar")
//@ImportResource(locations = {"classpath:security.xml"})
//@MapperScan(basePackages="com.ctsi",annotationClass= Mapper.class)
//@EnableScheduling
//@RestController
@Slf4j
public class WebApplication {

    private static final String SERVER_SSL_KEY_STORE = "server.ssl.key-store";

	/*@Bean
	public JmsListenerContainerFactory<?> queueListenerFactory() {
		DefaultJmsListenerContainerFactory factory = new DefaultJmsListenerContainerFactory();
		factory.setMessageConverter(messageConverter());
		return factory;
	}


	@Bean
	public MessageConverter messageConverter() {
		MappingJackson2MessageConverter converter = new MappingJackson2MessageConverter();
		converter.setTargetType(MessageType.TEXT);
		converter.setTypeIdPropertyName("_type");
		return converter;
	}*/


/*
    @Bean
    public RestTemplate restTemplate() {
        RequestConfig requestConfig = RequestConfig.custom()
                .setSocketTimeout(10000) //服务器返回数据(response)的时间，超过该时间抛出read timeout
                .setConnectTimeout(5000)//连接上服务器(握手成功)的时间，超出该时间抛出connect timeout
                .setConnectionRequestTimeout(1000)//从连接池中获取连接的超时时间，超过该时间未拿到可用连接，会抛出org.apache.http.conn.ConnectionPoolTimeoutException: Timeout waiting for connection from pool
                .build();
        Registry<ConnectionSocketFactory> registry = RegistryBuilder.<ConnectionSocketFactory>create()
                .register("http", PlainConnectionSocketFactory.getSocketFactory())
                .register("https", SSLConnectionSocketFactory.getSocketFactory())
                .build();
        PoolingHttpClientConnectionManager connectionManager = new PoolingHttpClientConnectionManager(registry);
        //设置整个连接池最大连接数 根据自己的场景决定
        connectionManager.setMaxTotal(200);
        //路由是对maxTotal的细分
        connectionManager.setDefaultMaxPerRoute(100);

        return new RestTemplate(
                new HttpComponentsClientHttpRequestFactory(
                        HttpClientBuilder.create()
                                .setDefaultRequestConfig(requestConfig)
                                .setConnectionManager(connectionManager)
                                .build()));
    }
*/


    public static void main(String[] args) throws UnknownHostException {
        String active = System.getenv("spring.profiles.active");
        String location = "classpath:/config/";

        if (ArrayUtils.isNotEmpty(args)) {
            for (String arg : args) {
                if (arg.contains("spring.profiles.active")) {
                    active = StringUtils.substringAfter(arg, "=").trim();
                    System.out.println("use profile: " + active);
                    continue;
                }
                if (arg.contains("spring.config.location")) {
                    location = StringUtils.substringAfter(arg, "=").trim();
                    System.out.println("config location: " + location);
                }
            }
        }
        if (StringUtils.isNotBlank(active)) {
            location = location + "," + location + '/' + active + "/";
        } else {
            active = "";
        }

        String[] properties = new String[]{
                "spring.config.name:server,context,app",
                "spring.config.location:" + location
        };
        System.out.println("total location: " + location);
        ConfigurableApplicationContext applicationContext =
                new SpringApplicationBuilder(WebApplication.class)
                        .properties(properties)
                        .build().run(args);

        ConfigurableEnvironment env = applicationContext.getEnvironment();

        String protocol = "http";
        if (env.getProperty(SERVER_SSL_KEY_STORE) != null) {
            protocol = "https";
        }
        System.out.printf("\n----------------------------------------------------------\n\t" +
                        "Application '%s' is running! Access URLs:\n\t" +
                        "Local: \t\t%s://localhost:%s%s\n\t" +
                        "External: \t%s://%s:%s%s\n\t" +
                        "Profile(s): \t%s\n----------------------------------------------------------",
                env.getProperty("spring.application.name"),
                protocol,
                env.getProperty("server.port"),
                env.getProperty("server.servlet.context-path"),
                protocol,
                InetAddress.getLocalHost().getHostAddress(),
                env.getProperty("server.port"),
                env.getProperty("server.servlet.context-path"),
//                env.getActiveProfiles());
                active);
    }

}
