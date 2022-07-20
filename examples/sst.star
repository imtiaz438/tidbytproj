load("render.star", "render")
load("http.star", "http")
load("encoding/base64.star", "base64")
load("cache.star", "cache")

SST_URL = "https://maps.googleapis.com/maps/api/directions/json?destination=place_id:EjoyMzA1IE10IFdlcm5lciBDaXIgIzIyOTEsIFN0ZWFtYm9hdCBTcHJpbmdzLCBDTyA4MDQ4NywgVVNBIiAaHgoWChQKEgmJJSIium5ChxHJJdlGCTLzMxIEMjI5MQ&mode=transit&transit_mode=bus&origin=place_id:ChIJiVJkhKVuQocRTGFT6kXQzy0&key=AIzaSyB5IFn4JK6kQXOH4RlHqmwg3RwXRdsmK4U"

# Load SST icon from base64 encoded data
SST_ICON = base64.decode("""
iVBORw0KGgoAAAANSUhEUgAAAA8AAAAFCAYAAACaTbYsAAAAAXNSR0IArs4c6QAAAEJJREFUKFNjZGBgYJB7FvYfRIPAI6lVjNjEkNXA1DKCBGEaYILYxLDJodiCbAjMJnwGgzXjsxHdFch8sLMJ+ReXBQAzWzpfYeMAgwAAAABJRU5ErkJggg==
""")

def main():
    rate_cached = cache.get("sst_time")
    if rate_cached != None:
        print ("Hit! Displaying Cached Data.")
    rate = int(rate_cached)
    else: 
        print ("Miss! Calling Google API.")
        rep = http.get(SST_URL)
        if rep.status_code != 200:
         fail("Google API request failed with status %d", rep.status_code)
        bus_time = rep.json()["routes"]["legs"]["steps"]["transit_details"]["depature_time"]["value"]
    print (bus_time)
    cache.set("sst_time", str(int(rate)), ttl_seconds=240)

    return render.Root(
        child = render.Box(
              render.Row(
              expanded=True,
        main_align="space_evenly",
        cross_align="center",
        children = [
            render.Image(src=SST_ICON),
            render.Text("%d" % bus_time),
            ],
        ),
    ),
    )
