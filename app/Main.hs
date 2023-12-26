{-# LANGUAGE OverloadedStrings #-}

import qualified Data.ByteString.Lazy.Char8 as LBS
import Network.HTTP.Req

-- Define your data type representing the structure of your CSV
data MyData = MyData
  { field1 :: Int
  , field2 :: Int
  , field3 :: Int
  -- Add more fields based on your CSV structure
  } deriving (Show, Generic)

-- Instances for automatic serialization using 'req' library
instance FromJSON MyData
instance ToJSON MyData

-- Main function to read CSV, convert to MyData, and save to SurrealDB
main :: IO ()
main = do
  -- Read the CSV file into a vector of MyData
  csvData <- readCSVFile "your_file.csv"
  case csvData of
    Left err -> putStrLn $ "Error reading CSV: " ++ err
    Right myDataVector -> do
      -- Assuming SurrealDB API endpoint is "https://surrealdb.example.com/api/data"
      let apiUrl = https "surrealdb.example.com" /: "api" /: "data" :: Url 'Https

      -- Make a POST request to SurrealDB API
      response <- runReq defaultHttpConfig $ req POST apiUrl (ReqBodyJson myDataVector) jsonResponse mempty

      -- Print the response
      liftIO $ print (responseBody response :: Value)
