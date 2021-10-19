import main
import unittest


class TestHelloWorld(unittest.TestCase):

    def setUp(self):
        self.app = main.app.test_client()
        self.app.testing = True

    def test_status_code(self):
        response = self.app.get('/')
        self.assertEqual(response.status_code, 200)

    def test_message(self):
        response = self.app.get('/')
        self.assertDictEqual({"id": 1, "message": "HelloWorld From Python"}, response.json)

if __name__ == '__main__':
    unittest.main()
