
# Multi-Account Registration for AWS IoT and STM32 Microcontroller

## 1. Overview
AWS Multi-Account Registration (MAR) is a feature of AWS IoT Core that simplifies the device registration process and allows for easy movement of devices between multiple AWS accounts within the same region. This feature is particularly useful for STM32 applications with the use of an STSAFE secure element. The STSAFE module stores the device certificate, private key, and configuration parameters securely, ensuring that the registration process is secure and reliable. By leveraging Multi-Account Registration, developers can register device certificates directly without needing a Certificate Authority (CA) to be registered with AWS IoT. This streamlines the process of moving devices from one account to another by simply changing the AWS IoT Core endpoint the devices connect to. Additionally, STMicroelectronics can provide custom-built STSAFE modules with X.509 certificates, private keys, and configuration to address developer-specific needs and ensure components are qualified to connect to AWS IoT by default. Use this [link](https://aws.amazon.com/about-aws/whats-new/2020/04/simplify-iot-device-registration-and-easily-move-devices-between-aws-accounts-with-aws-iot-core-multi-account-registration/) to learn more about Multi-Account Registration 

## 2. MAR Flow
With AWS Multi-Account Registration (MAR), the customer will receive a list of the certificates that are programmed into their custom-built STSAFE. The customer can use bulk registration to register their devices with AWS IoT Core. This operation can be performed independently from the production environment, making the process more efficient and reducing the complexity of device management. The secure element (STSAFE) ensures that the device certificates, private keys, and configuration parameters are stored securely, providing an added layer of security during the registration process.

>Note: The following registration flow is for demo purposes only.

The User will need to:
1. Build the project or use the supplied `b_u585_iota02_aws_iot.bin` file.
2. Flash the Firmware to STM32
3. Use a serial terminal to:
   * Upload AWS RootCA certificate
   * Set Wi-Fi SSID
   * Set Wi-Fi Password
   * Set AWS endpoint
   * Set MQTT Port

## 3. Prerequisites
- **[B-U585I-IOT02A](https://www.st.com/en/evaluation-tools/b-u585i-iot02a.html)**
- **[AWS Account](https://aws.amazon.com/)**: Access to an AWS account with permissions to manage IAM, IoT
## 4. Files
Description of the files on this repository
1. **config.json**
   - Configuration file for Fleet Provisioning.

2. **config.sh / config.ps1**
   - Connect to the board over serial port and:
     * Upload AWS RootCA certificate
     * Set Wi-Fi SSID
     * Set Wi-Fi Password
     * Set AWS endpoint
     * Set MQTT Port
3. **deviceCleanup.sh**
   - Cleans up IoT resources by deleting the IoT Thing and its certificates.


4. **b_u585_iota02_aws_iot.bin**
   - Prebuilt binary for MAR

---

## 5. Setup Steps
### 5.1. Clone the Repositories

```bash
git clone https://github.com/SlimJallouli/stm32mcu_aws_mar
```

### 5.2. Update config.json
open `config.json` with a text editor and update:
* mqtt_endpoint: Your AWS Endpoint address
* mqtt_port: MQTT port (default: 8883)
* wifi_ssid: You Wi-Fi SSID
* wifi_credential: Your Wi-Fi password
* portName: Your board com port number

### 5.3 Flash the b_u585_iota02_aws_iot.bin

You can use the `b_u585_iota02_aws_iot.bin`. You can drag and drop the file to your **[B-U585I-IOT02A](https://www.st.com/en/evaluation-tools/b-u585i-iot02a.html)**

![alt text](<assets/Screenshot 2025-02-27 132734.png>)

### 5.4 Build the project

Follow this [git repo](https://github.com/SlimJallouli/b_u585_iota02_aws_iot) for building the project


## 6 Configure your boards
To ensure your STM32 board properly connects to AWS, you must configure your board by sending the following over UART using AWS CLI commands:

 1. - AWS RootCA.
 2. - AWS endpoint.
 3. - MQTT port.
 4. - Wi-Fi SSID.
 5. - Wi-Fi password.
 6. - Commit the changes.
 7. - Read the device certificate
 8. - Reset the board.

>NOTE:All of the parameters and the AWS RootCA going to be stored on STSAFE.

You have two options to configure your board:

1. - Manual Option: Manually send each command through a serial terminal.
2. - Automated Option: Use the provided configuration script to automate the process.

### 6.1 Manual option
#### 6.1.1. Import the Amazon Root CA Certificate
Use the *pki import cert root_ca_cert* command to import the Root CA Certificate.
For this demo, we recommend you use the ["Starfield Services Root Certificate Authority - G2](https://www.amazontrust.com/repository/SFSRootCAG2.pem) Root CA Certificate which has signed all four available Amazon Trust Services Root CA certificates.

Copy/Paste the contents of [SFSRootCAG2.pem](https://www.amazontrust.com/repository/SFSRootCAG2.pem) into your serial terminal after issuing the ```pki import cert``` command.
```
pki import cert root_ca_cert
-----BEGIN CERTIFICATE-----
MIID7zCCAtegAwIBAgIBADANBgkqhkiG9w0BAQsFADCBmDELMAkGA1UEBhMCVVMx
EDAOBgNVBAgTB0FyaXpvbmExEzARBgNVBAcTClNjb3R0c2RhbGUxJTAjBgNVBAoT
HFN0YXJmaWVsZCBUZWNobm9sb2dpZXMsIEluYy4xOzA5BgNVBAMTMlN0YXJmaWVs
ZCBTZXJ2aWNlcyBSb290IENlcnRpZmljYXRlIEF1dGhvcml0eSAtIEcyMB4XDTA5
MDkwMTAwMDAwMFoXDTM3MTIzMTIzNTk1OVowgZgxCzAJBgNVBAYTAlVTMRAwDgYD
VQQIEwdBcml6b25hMRMwEQYDVQQHEwpTY290dHNkYWxlMSUwIwYDVQQKExxTdGFy
ZmllbGQgVGVjaG5vbG9naWVzLCBJbmMuMTswOQYDVQQDEzJTdGFyZmllbGQgU2Vy
dmljZXMgUm9vdCBDZXJ0aWZpY2F0ZSBBdXRob3JpdHkgLSBHMjCCASIwDQYJKoZI
hvcNAQEBBQADggEPADCCAQoCggEBANUMOsQq+U7i9b4Zl1+OiFOxHz/Lz58gE20p
OsgPfTz3a3Y4Y9k2YKibXlwAgLIvWX/2h/klQ4bnaRtSmpDhcePYLQ1Ob/bISdm2
8xpWriu2dBTrz/sm4xq6HZYuajtYlIlHVv8loJNwU4PahHQUw2eeBGg6345AWh1K
Ts9DkTvnVtYAcMtS7nt9rjrnvDH5RfbCYM8TWQIrgMw0R9+53pBlbQLPLJGmpufe
hRhJfGZOozptqbXuNC66DQO4M99H67FrjSXZm86B0UVGMpZwh94CDklDhbZsc7tk
6mFBrMnUVN+HL8cisibMn1lUaJ/8viovxFUcdUBgF4UCVTmLfwUCAwEAAaNCMEAw
DwYDVR0TAQH/BAUwAwEB/zAOBgNVHQ8BAf8EBAMCAQYwHQYDVR0OBBYEFJxfAN+q
AdcwKziIorhtSpzyEZGDMA0GCSqGSIb3DQEBCwUAA4IBAQBLNqaEd2ndOxmfZyMI
bw5hyf2E3F/YNoHN2BtBLZ9g3ccaaNnRbobhiCPPE95Dz+I0swSdHynVv/heyNXB
ve6SbzJ08pGCL72CQnqtKrcgfU28elUSwhXqvfdqlS5sdJ/PHLTyxQGjhdByPq1z
qwubdQxtRbeOlKyWN7Wg0I8VRw7j6IPdj/3vQQF3zCepYoUz8jcI73HPdwbeyBkd
iEDPfUYd/x7H4c7/I9vG+o1VTqkC50cRRj70/b17KSa7qWFiNyi2LSr2EIZkyXCn
0q23KXB56jzaYyWf/Wi3MOxw+3WKt21gZ7IeyLnp2KhvAotnDU0mV3HaIPzBSlCN
sSi6
-----END CERTIFICATE-----
```

#### 6.1.4. Set Config
- Use a serial terminal to:
   * Set Wi-Fi SSID
   * Set Wi-Fi Password
   * Set AWS endpoint
   * Set MQTT Port

>Not: The certificate CN is used as thing_name.

The thing name will be in the form of `eval3-XXXXXXXXXXXXXXXXXXXXXXXX`

```
conf set mqtt_endpoint abcdefjhtvew8t-ats.iot.us-west-2.amazonaws.com 
conf set mqtt_port 8883
conf set wifi_ssid <Your Wi-Fi SSID>
conf set wifi_credential <Your Wi-Fi Password>
conf commit
reset
```
### 6.2 Automated Option
#### 6.2.1 Update the config.json file
Open the `config.json` file and update the follwing

  * "mqtt_endpoint": "abcdefjhtvew8t-ats.iot.us-west-2.amazonaws.com",
  * "mqtt_port": 8883,
  * "wifi_ssid": "MySSID",
  * "wifi_credential": "MyPSWD",
  * "portName": "MyBoardComPort",
  * Update the `certificateFile`, `privateKeyFile` and `root_ca_cert` paths depending on your OS (Default Windows)

![alt text](<assets/Screenshot 2025-02-27 133913.png>)

  #### 6.2.2 Run the config script

Before running the script, make sure that you don't have any applucation (TeraTerm for example) connected to the board's COM port.

Depending on you operating systrem, run `config.ps1` on windows, `config.sh` on Linux

  #### 6.2.3 Check your configuration
  Use a serial terminal (TeraTerm or [Web Based Serial Terminal](https://googlechromelabs.github.io/serial-terminal/)) to connect to your board

Type the following command to get your configuration
  ```
conf get
```

![alt text](<assets/Screenshot 2025-02-27 140101.png>)

Type the following command to get the AWS RootCA
  ```
pki export cert root_ca_cert
```
![alt text](<assets/Screenshot 2025-02-27 140415.png>)

Now we are sure that everything is properly configured on STM32 side.

## 7 Register your boards with AWS
### 7.1 Read the device certificate

Type the following command to get the device certificate
  ```
pki export cert tls_cert
```
![alt text](<assets/Screenshot 2025-02-27 140955.png>)

copy the certificate content to a new text docment

![alt text](<assets/Screenshot 2025-02-27 141202.png>)

save the file with extension .pem

![alt text](<assets/Screenshot 2025-02-27 141417.png>)

### 7.2 Read the ThingName

Type the following command to get your configuration. and save the thing name. Example `eval3-02090046215AD42AC2013`

  ```
conf get
```
![alt text](<assets/Screenshot 2025-02-27 141651.png>)

### 7.3 Register with AWS

* Open AWS Console
* Click on "Create Things"

![alt text](<assets/Screenshot 2025-02-27 142129.png>)

* Select "Create single Thing" and click Next

![alt text](<assets/Screenshot 2025-02-27 142516.png>)

* On the "Thing Name" use the thing name we have copyed earlier then click Next

![alt text](<assets/Screenshot 2025-02-27 142735.png>)

Select:
* Use my certificate
* CA is not registered with AWS IoT
* Upload your certificate that we have seved earlier and click Next

![alt text](<assets/Screenshot 2025-02-27 143013.png>)

* You can select an existing policy or create new one.

To create new policy, click on "Create policy"

![alt text](<assets/Screenshot 2025-02-27 143349.png>)


* Give your policy a name
* Select JSON
* Click Create

Paste the following policy. Note you need to define a policy that fits your need. The following policy is generic and should be uopdate for your need.


  ```
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "iot:*",
      "Resource": "*"
    }
  ]
}
```

![alt text](<assets/Screenshot 2025-02-27 143632.png>)

* Go back to the "Create thing" tab
* Search for your newly created cert
* Click "Create Thing"

![alt text](<assets/Screenshot 2025-02-27 144123.png>)

* Rest your board
* Now your board will connect to AWS and start publishing MQTT messages

![alt text](<assets/Screenshot 2025-02-27 144435.png>)

