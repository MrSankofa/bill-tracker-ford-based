package com.altruisticsoftwaredevelopment.bill_tracker_ford_based_backend.health;

import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.web.server.LocalServerPort;

import static org.assertj.core.api.Assertions.assertThat;

@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
class HealthControllerTest {

    @LocalServerPort
    int port;

    @Test
    void healthEndpointReturnsOk() throws Exception {
        var url = new java.net.URL("http://localhost:" + port + "/api/health");
        var conn = (java.net.HttpURLConnection) url.openConnection();
        conn.setRequestMethod("GET");

        assertThat(conn.getResponseCode()).isEqualTo(200);

        try (var in = new java.io.BufferedReader(new java.io.InputStreamReader(conn.getInputStream()))) {
            var body = in.readLine();
            assertThat(body).isEqualTo("ok");
        }
    }
}
