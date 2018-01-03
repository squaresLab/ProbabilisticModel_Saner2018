#!/usr/bin/python

#How to use: python ExtractGitHubRepos.py "githubUrl" 10 > sampleRepos.txt
#param 2 can only be a multiple of 10. Ex:10,20,100,120, etc.

#This program scrapes the github search results for java and prints the github clone link for the respositories.  Be aware that GitHub does not produce the same results every time when the user searches for java. 

from bs4 import BeautifulSoup
import urllib2
import time
import sys

startingUrl = sys.argv[1]
githubString="https://github.com"

def main():
  numberOfReposToExtract=int(sys.argv[2]) #This only works in increments of ten
  numberOfRepoPagesToExtract=numberOfReposToExtract/10
  soup = openPage(startingUrl)
  for x in range(numberOfRepoPagesToExtract):
    extractRepos(soup)
    nextUrl = getNextUrl(soup)
    soup = openPage(nextUrl)
    
  
  #print(nextUrl)
  #print(soup.prettify())

def extractRepos(soup):
  repoListElement = soup.find(class_="repo-list js-repo-list")
  repoItems = repoListElement.find_all("li")
  for item in repoItems:
    time.sleep(1)
    repoUrl = githubString+unicode(item.h3.a["href"])
    #print "repo: %s" % repoUrl
    repoSoup  = openPage(repoUrl)
    repoGitLink = repoSoup.find(class_="js-url-field")
    #print repoGitLink
    finalRepoLink = repoGitLink["value"]
    print finalRepoLink



def openPage(urlString):
  htmlDoc = urllib2.urlopen(urlString)
  soup = BeautifulSoup(htmlDoc)
  return soup

def getNextUrl(soup):
  pageLinks = soup.find(class_="pagination")
  currentPage = pageLinks.find(class_="current")
  nextPageLink = currentPage.find_next_sibling("a")
  nextPageUrl = githubString+unicode(nextPageLink["href"])
  return nextPageUrl


if __name__ == "__main__":
  main()
