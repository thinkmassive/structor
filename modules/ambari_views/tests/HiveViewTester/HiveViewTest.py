from optparse import OptionParser

from selenium import webdriver
from selenium.webdriver.common.keys import Keys
import os.path
import time
import pyautogui
import textwrap
import clipboard

shortSleep = 0.1
briefSleep = 0.5
renderSleep = 3

def load_view():
	user = "vagrant"
	password = "vagrant"
	ambariServer = "%s:%s@node1:8080" % (user, password)
	hiveView = "http://%s/#/main/views/HIVE/1.0.0/Hive" % ambariServer

	# Load
	driver = webdriver.Firefox()
	driver.maximize_window()

	# Login
	driver.get(hiveView)
	time.sleep(briefSleep)
	element = driver.find_element_by_class_name("login-user-name")
	element.send_keys("vagrant")
	element = driver.find_element_by_class_name("login-user-password")
	element.send_keys("vagrant")
	driver.find_element_by_class_name("login-btn").click()
	time.sleep(renderSleep)

	# Go to Hive view
	driver.get(hiveView)
	time.sleep(renderSleep)

	# Switch to the right iframe
	frame = driver.find_elements_by_tag_name('iframe')[0]
	driver.switch_to_frame(frame)
	return driver

def adjustXOffset():
	(x, y) = pyautogui.size()
	return (x - 1440) * 1.0 / 2

def setDatabaseFoodmart():
	offset = adjustXOffset()
	pyautogui.moveTo(200+offset, 300)
	pyautogui.click()
	pyautogui.moveTo(200+offset, 360)
	time.sleep(shortSleep)
	pyautogui.click()
	time.sleep(shortSleep)

def runQuery(driver, text):
	offset = adjustXOffset()
	pyautogui.moveTo(600+offset, 400)
	pyautogui.click()

	# Clear the buffer.
	time.sleep(shortSleep)
	pyautogui.hotkey('command', 'a')
	time.sleep(shortSleep)
	pyautogui.press('del')
	time.sleep(shortSleep)

	# New query.
	clipboard.copy(text)
	pyautogui.hotkey('command', 'v')
	time.sleep(shortSleep)
	#pyautogui.typewrite(text)
	try:
		execute = driver.find_element_by_class_name("execute-query")
	except:
		time.sleep(1)
		execute = driver.find_element_by_class_name("execute-query")
	execute.click()
	magicString = "previous next"
	startTime = time.time()
	time.sleep(0.5)
	while 1:
		time.sleep(0.5)
		try:
			results = driver.find_element_by_class_name("query-process-results-panel")
		except:
			# Failed query
			print "Failed query, returning"
			return 1
		if results.text.find(magicString) > -1:
			endTime = time.time()
			totalTime = endTime - startTime
			print "Query is done, time = %f" % totalTime
			time.sleep(1)
			return 0

def screenshotExplain(driver, file):
	button = driver.find_element_by_id("visual-explain-icon")
	button.click()
	time.sleep(renderSleep)
	driver.save_screenshot(file)
	button = driver.find_element_by_id("query-icon")
	button.click()
	time.sleep(briefSleep)

def screenshotTez(driver, file):
	offset = adjustXOffset()
	file1 = "details-" + file
	file2 = "graphical-" + file
	button = driver.find_element_by_id("tez-icon")
	button.click()
	time.sleep(renderSleep)
	driver.save_screenshot(file1)

	# Click on the graphical view. There is no fixed ID given this element.
	pyautogui.moveTo(790+offset, 360)
	pyautogui.click()
	time.sleep(renderSleep)
	driver.save_screenshot(file2)

	# Back to the SQL panel.
	button = driver.find_element_by_id("query-icon")
	button.click()
	time.sleep(briefSleep)

def screenshotVisualization(driver, file):
	button = driver.find_element_by_id("visualization-icon")
	button.click()
	time.sleep(renderSleep)
	driver.save_screenshot(file)
	button = driver.find_element_by_id("query-icon")
	button.click()
	time.sleep(briefSleep)

def main():
	# TODO: Options.
	parser = OptionParser()
	thinkTime = 0
	skipTrivial = False
	clicks = { "visualization" : False, "explain" : False, "tez" : False }

	strategy = "gottaGoFast"
	if strategy == "clickEverything":
		skipTrivial = True
		thinkTime = 0
		for k in clicks.keys():
			clicks[k] = True
	elif strategy == "gottaGoFast":
		thinkTime = 0
	elif strategy == "justThink":
		skipTrivial = True
		thinkTime = 15

	driver = load_view()
	setDatabaseFoodmart()

	i = 1
	with open("queries.txt") as fd:
		for query in fd:
			# Skip if we've already done this query.
			vizFile = "viz-" + file
			explainFile = "explain-" + file
			if os.path.exists(vizFile):
				continue

			if skipTrivial and query.find("as c1") == -1:
				continue

			query = "\n".join(textwrap.wrap(query))
			print query
			result = runQuery(driver, query)
			if result == 0:
				# Screenshots of visualizations, explain and tez.	
				file = "%05d" % i + ".png"
				if clicks["visualization"]:
					screenshotVisualization(driver, "viz-" + file)
				if clicks["explain"]:
					screenshotExplain(driver, "explain-" + file)
				if clicks["tez"]:
					screenshotTez(driver, "tez-" + file)
				if thinkTime > 0:
					print "Waiting for %d seconds" % thinkTime
					time.sleep(thinkTime)
			i += 1

if __name__ == "__main__":
	main()
else:
	driver = load_view()
