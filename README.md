# Digital Distribution System (DDS)

## Description
DDS is a cloud-enabled software platform that enables the FMCG ecosystem to achieve operational excellence by digitizing the ordering, distribution, invoicing and real-time payment reconciliation processes while providing data for informed commercial visibility and decision making to the business.
The solution is highly customizable, Natively Multi-tenant and secure. It improves efficiency by automating processes, enforcing accountability, providing visibility and ultimately ensuring customer delight.

## Getting Started
1. Download / Clone the repository
2. Run the command flutter pub get
3. Update the dependencies
4. Build / Update routing dependencies flutter pub run build_runner build --delete-conflicting-outputs

## Usage
This solution is available in different flavors to meet client and development needs. 

## Architecture
Its is based on an MVVP architecture. 
The solution is geared towards a multi-tenancy environment.  To make this possible runtime environment variables are initialized based on the flavor, ensuring minimal changes in the base code base for multiple tenants.
The various flavours are located on the app/build.gradle file
``demo {
    dimension "buildGroup"
    applicationIdSuffix ".demo"
    versionNameSuffix "-demo"
}``
Independent resources are located in the android\src\demo folder.
Depending on the tenant requirements, initialization is done on startup using the InitService. 

The InitService is responsible for the views and subsequentl the functionality available to the tenant.
Setup of the runtime configurations is handled by the ``AppEnv`` class. 

Each flavor has a related main{_flavorName} file on that depends on this class. 

## Deployment
The solution is deployed using external third parties. It is built for Android devices.
To build the required flavor run the command "flutter build apk --flavor {flavorName} -t lib/{flavorName}"

## Dependency
See pubspec.yaml for required dependencies.
The solution additionally utilizes Google Firebase for analytics and remote configurations for flavors that utilize the automatic update functionality.

## API
The full API documentation can be found on [https://testdds.ddsolutions.tech/spvdev-backend/swagger-ui.html#/]

