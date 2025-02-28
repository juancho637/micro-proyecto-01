const Consul = require('consul');
const express = require('express');
const os = require('os');
const hostname = os.hostname();
const SERVICE_NAME='mymicroservice';
const SERVICE_ID = 'm' + process.argv[2] + '-' + hostname;
const SCHEME='http';
const HOST='ip-server';
const PORT=process.argv[2]*1;
const PID = process.pid;

/* Inicializacion del server */
const app = express();
const consul = new Consul({
  host: '192.168.100.15', // Reemplaza con la IP del agente de Consul
  port: 8500
});

app.get('/health', function (req, res) {
    console.log('Health check!');
    res.end( "Ok." );
    });

app.get('/', (req, res) => {
  console.log('GET /', Date.now());
  res.json({
    data: Math.floor(Math.random() * 89999999 + 10000000),
    data_pid: PID,
    data_service: SERVICE_ID,
    data_host: HOST
  });
});

app.listen(PORT, function () {
    console.log('Servicio iniciado en:'+SCHEME+'://'+HOST+':'+PORT+'!');
    });
      
      // Registro del servicio en Consul
      const check = {
        id: SERVICE_ID,
        name: SERVICE_NAME,
        address: HOST,
        port: PORT, 
        check: {
          http: `${SCHEME}://${HOST}:${PORT}/health`,
          ttl: '5s',
          interval: '5s',
          timeout: '5s',
          deregistercriticalserviceafter: '1m'
        }
      };
      
      consul.agent.service.register(check, (err) => {
        if (err) {
          console.error("Error al registrar el servicio en Consul:", err);
          return;
        }
        console.log("Servicio registrado en Consul exitosamente.");
      });