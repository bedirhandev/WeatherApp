# weather_app

Een Flutter app die toont wat voor weer het is in de steden in Nederland.

# Extra bestanden die aan dit project is toegevoegd

- Het mapje 'lib', bevat alle bussiness logic.

- Het bestand 'pubspec.yaml', bevat een locatie naar het mapje 'asset' met daarin een link naar het logo. De dependency 'firebase_auth' (de nieuwste versie) is toegevoegd, zodat deze in de bussiness logic gebruikt kan worden. Er is een extra map onder de root folder met het logo plaatje.

- Aan het mapje 'ios' is het bestand 'GoogleService-Info.plist' toegevoegd, daarna wordt deze via Xcode gerefereert naar datzelfde bestand.

- Aan het mapje 'android' is het bestand 'android/app/google-services.json' toegevoegd, daarna worden in alle build.gradle bestanden een paar dependencies toegevoegd. Zie op de site van Firebase voor meer info.

# Uitleg bussiness logica (globaal)

- Het bestand main.dart bevat de main app.
- Het bestand Mapping.dart bevat alle logica omtrent Firebase. Het vraagt aan de database of de gebruiker ingelogd is of niet. En maakt daaropvolgend een beslissing naar welke pagina die gaat.
- Het bestand AuthenticationPage.dart bevat de login en registratie formulier. Het kijkt of de gebruiker bevoegd is om te registeren of in te loggen (refereert naar het bestand Authentication.dart), en update als gevolg de statussen of de gebruiker wel of niet ingelogd is en of de gebruiker een login of registratie actie heeft uitgevoerd.
- Het bestand Authentication.dart, bevat een model voor alle Firebase acties.
- Het bestand HomePage.dart, is de homepagina van de app. Er gebeurt daarin nog niks speciaals.