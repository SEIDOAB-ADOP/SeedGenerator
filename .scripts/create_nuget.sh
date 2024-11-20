#!/bin/bash
#To make the .sh file executable
#sudo chmod +x ./create_local_nuget.sh

# create local nuget directory, e.g.
# /Users/Martin/Development/nugets

# add the directory as a local nuget feed
# in /Users/Martin/.nuget/NuGet/NuGet.Config under <packageSources> add below line
#   <add key="localfeed" value="/Users/Martin/Development/nugets" />

#must give version as an argument
if [[ -z $1 ]]; then
    echo "Verson to publish must be provided, e.g. 1.0.1";
    exit 1;
fi


NUGET_NAME="SeedGenerator"
NUGET_ID="Seido.Utilities.$NUGET_NAME"
APPUSAGE_NAME="AppUsage"

NUGET_CSPROJ_DIR="../$NUGET_NAME"
NUGET_CSPROJ_FILE="$NUGET_CSPROJ_DIR/$NUGET_NAME.csproj"
NUGET_File="$NUGET_CSPROJ_DIR/$NUGET_ID.$1.nupkg"

APPUSAGE_CSPROJ_DIR="../$APPUSAGE_NAME"
APPUSAGE_CSPROJ_FILE="$APPUSAGE_CSPROJ_DIR/$APPUSAGE_NAME.csproj"

LOCAL_FEED="/Users/Martin/Development/seidoNugets"
PUBLISH_FEED="https://pkgs.dev.azure.com/martinlenart/seidoNugets/_packaging/seidoNugets/nuget/v3/index.json"

# Property to modify
VERSION="$1"

# Use sed to modify Version in the Nuget project
#https://sed.js.org/#
#https://stackoverflow.com/questions/45018156/using-sed-for-search-and-replace-multi-digits
#sed -r 's/(<Version>)[0-9]+[.][0-9]+[.][0-9]+(<\/Version>)/\1replace\2/' ../seedGenerator/seedGenerator.csproj
sed -i '.bak' -r "s/(<Version>)[0-9]+[.][0-9]+[.][0-9]+(<\/Version>)/\1$VERSION\2/" $NUGET_CSPROJ_FILE
echo "Updated version to $VERSION in $NUGET_CSPROJ_FILE"


# Use sed to modify Version in the AppUsage project
#https://superuser.com/questions/112834/how-to-match-whitespace-in-sed
#sed -r "s/(<PackageReference[ \t]+Include=\"Seido[.]Utilities[.]SeedGenerator\"[ \t]+Version=\")[0-9]+[.][0-9]+[.][0-9]+(\"[ \t]*\/>)/\1replace\2/" ../AppUsage/AppUsage.csproj
sed -i '.bak' -r "s/(<PackageReference[ \t]+Include=\"$NUGET_ID\"[ \t]+Version=\")[0-9]+[.][0-9]+[.][0-9]+(\"[ \t]*\/>)/\1$VERSION\2/" $APPUSAGE_CSPROJ_FILE
echo "Updated version to $VERSION in $APPUSAGE_CSPROJ_FILE"

#clear the local nuget cache
dotnet nuget locals all --clear

#build the nuget package project
dotnet build $NUGET_CSPROJ_FILE

#create the nuget package
dotnet pack $NUGET_CSPROJ_FILE -o $NUGET_CSPROJ_DIR

#publish the nuget package to local feed
dotnet nuget push $NUGET_File -s $LOCAL_FEED
echo "Local publish to $LOCAL_FEED completed";


if [[ $2 == 'publish' ]]; then
    
    dotnet nuget push $NUGET_File -s $PUBLISH_FEED --api-key seido
    echo "Artifact publish to $PUBLISH_FEED completed";
fi
