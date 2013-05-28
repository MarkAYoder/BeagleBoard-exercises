import urllib
import simplejson

# From http://glowingpython.blogspot.de/2011/04/how-to-use-twitter-search-api.html

def searchTweets(query):
 search = urllib.urlopen("http://search.twitter.com/search.json?q="+query)
 dict = simplejson.loads(search.read())
# print dict["results"]
 for result in dict["results"]: # result is a list of dictionaries
  print "*", result["text"]

# we will search tweets about "fc liverpool" football team
searchTweets("yoder")
