import pytest
import time
from selenium import webdriver
from selenium.webdriver.chrome.service import Service as ChromeService
from webdriver_manager.chrome import ChromeDriverManager
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC

TARGET_URL = "https://smart-press-website.onrender.com"

@pytest.fixture(scope="module")
def driver():
    """
    Pytest fixture to initialize headless Chrome web driver with auto-managed ChromeDriver
    and retry connection handling to account for Render cold-starts.
    """
    options = webdriver.ChromeOptions()
    options.add_argument("--headless")
    options.add_argument("--no-sandbox")
    options.add_argument("--disable-dev-shm-usage")
    options.add_argument("--disable-gpu")
    options.add_argument("--window-size=1920,1080")
    
    # Auto-manage ChromeDriver version matching the runner's Chrome browser
    service = ChromeService(ChromeDriverManager().install())
    driver = webdriver.Chrome(service=service, options=options)
    
    # Warm up / Cold-start connection retry loop
    max_retries = 5
    retry_delay = 15
    connected = False
    
    for attempt in range(max_retries):
        try:
            print(f"Connecting to {TARGET_URL} (Attempt {attempt + 1}/{max_retries})...")
            driver.get(TARGET_URL)
            # Wait up to 10 seconds for the body tag to render
            WebDriverWait(driver, 10).until(
                EC.presence_of_element_located((By.TAG_NAME, "body"))
            )
            print("Successfully loaded application page.")
            connected = True
            break
        except Exception as e:
            print(f"Attempt {attempt + 1} failed: {str(e)}")
            if attempt < max_retries - 1:
                print(f"Retrying in {retry_delay} seconds...")
                time.sleep(retry_delay)
            else:
                driver.quit()
                raise RuntimeError(
                    f"Render cold start timeout: Could not connect to {TARGET_URL} after {max_retries} attempts."
                ) from e
                
    yield driver
    driver.quit()

def test_homepage_loads_successfully(driver):
    """
    Test 1: Verify the website loads successfully with accessibility enabled,
    and the title matches the application name 'smart_press'.
    """
    driver.get(f"{TARGET_URL}/?enable-accessibility=true")
    
    # Wait for the page title to change from empty to the app name (smart_press)
    # Flutter web apps load a shell and then render the main script.
    WebDriverWait(driver, 20).until(
        lambda d: d.title != "" and "smart_press" in d.title.lower()
    )
    
    page_title = driver.title
    print(f"Loaded page title: {page_title}")
    assert "smart_press" in page_title.lower(), f"Unexpected page title: '{page_title}'"

def test_owner_login_button_present(driver):
    """
    Test 2: Verify the 'Owner Login' button is present in the rendered DOM.
    Since Flutter is compiled web code, checking accessibility elements (flt-semantics)
    along with text fallback is the most robust way to find buttons.
    """
    driver.get(f"{TARGET_URL}/?enable-accessibility=true")
    
    # Match flt-semantics element with label or text content
    xpath_selector = (
        '//flt-semantics[contains(@aria-label, "Owner Login")] | '
        '//*[contains(text(), "Owner Login")]'
    )
    
    # Wait for the element to be present and visible
    element = WebDriverWait(driver, 20).until(
        EC.visibility_of_element_located((By.XPATH, xpath_selector))
    )
    
    assert element is not None, "Owner Login button element was not found in the DOM"
    assert element.is_displayed(), "Owner Login button element is present but not displayed"
    print("Verified presence of the 'Owner Login' button.")

def test_url_structure_and_params(driver):
    """
    Test 3: Verify that navigating to the site loads the domain,
    and check if accessibility param or standard Flutter URL path works.
    """
    driver.get(f"{TARGET_URL}/?enable-accessibility=true")
    
    # Wait for the body tag to render
    WebDriverWait(driver, 10).until(
        EC.presence_of_element_located((By.TAG_NAME, "body"))
    )
    
    current_url = driver.current_url
    print(f"Loaded Page URL: {current_url}")
    
    # Assert that we are on the correct host
    assert "smart-press-website.onrender.com" in current_url, f"Redirected to unknown domain: {current_url}"
    # Verify that accessibility has been initialized or is present in URL query/hash params
    assert "enable-accessibility" in current_url, f"Accessibility query parameter lost during route: {current_url}"
