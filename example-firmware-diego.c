PRODUCT_ID(536);
PRODUCT_VERSION(1);

//Prototipo de MrWattson
//Software de prueba para la configuración de las apps mobile

//dos threads independientes -codigo y usuario y sistema-
//conexion manual a la nube
SYSTEM_THREAD(ENABLED);
SYSTEM_MODE(SEMI_AUTOMATIC);

//SSID de MrWattson
//TEMP
//System.set(SYSTEM_CONFIG_SOFTAP_PREFIX, "MrWattson");

//antena del WIFi default en interna, cambiamos a externa
STARTUP(WiFi.selectAntenna(ANT_EXTERNAL));

//variables varias
int led_stat = 0;

//asignaciones hw
int SW_CAL = D0;

/////////////////////////////////////////////////////////////////////CLEAR CRED
void Clear_cred() {

  //tomo el control del LED del sistema
  RGB.control(true);
  RGB.color(255, 255, 255);
  RGB.brightness(128);

  //espero que se suelte el pulsador de calibracion
  while(!digitalRead(SW_CAL)) {
    delay(50);
  }
  //anti-bouncing delay
  RGB.brightness(0);
  delay(2000);

  if(!WiFi.clearCredentials()) {
  //si hay un error: 55 blinks rojos
    RGB.color(255, 0, 0);
    for(int i=0;i<55;i++) {
      RGB.brightness(255);
      delay(400);
      RGB.brightness(0);
      delay(200);
    }
  }

  RGB.brightness(255);
  RGB.control(false);
}

//////////////////////////////////////////////////////////////////////////SETUP
void setup() {

    //pulsador CAL/CONFIG en D0, activo a masa
    pinMode(D0, INPUT_PULLUP);

   //expongo variables a la nube (se puede llamar antes de conectarse)
    Particle.variable("LS", led_stat);

}

///////////////////////////////////////////////////////////////////////////LOOP
void loop() {

//si esta presionado CAL/CONFIG button al momento del encendido,
//borramos credenciales WiFi para forzar el setup del WiFi
if(!digitalRead(SW_CAL)) {
  Clear_cred();
  }

//llamamos a la nube, espera forever
Particle.connect();
waitUntil(Particle.connected);
//para separar los LED de status
delay(2000);

//forever aqui
while(true){

  //tomo el control del LED del sistema
  RGB.control(true);
  RGB.color(0, 255, 255);
  RGB.brightness(255);

  String data = "0|12345.12|23456.12|-1|12345.12|23456.12|-2|12345.12|23456.12|-3|12345.12|23456.12";

  while(true) {
    Particle.publish("reading-event", data);
    RGB.brightness(255);
    led_stat = 0;
    delay(6000);
    RGB.brightness(0);
    led_stat = 1;
    delay(6000);
  }
}
}
////////////////////////////////////////////////////////////////////////////END
