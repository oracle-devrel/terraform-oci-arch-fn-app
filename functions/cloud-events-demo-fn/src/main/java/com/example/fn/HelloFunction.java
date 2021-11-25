package com.example.fn;

import com.fnproject.fn.api.FnConfiguration;
import com.fnproject.fn.api.RuntimeContext;

import com.drew.imaging.ImageMetadataReader;
import com.drew.imaging.ImageProcessingException;
import com.drew.metadata.Metadata;
import com.fasterxml.jackson.databind.ObjectMapper;
import io.cloudevents.CloudEvent;

import java.io.IOException;
import java.io.InputStream;
import java.net.URL;
import java.util.Map;

public class HelloFunction {
    
    private String region;

    @FnConfiguration
    public void config(RuntimeContext ctx) {
        region = ctx.getConfigurationByKey("REGION").orElse("your-region");
    }

    public Metadata handleRequest(CloudEvent event) throws IOException, ImageProcessingException {
        ObjectMapper objectMapper = new ObjectMapper();
        Map data = objectMapper.convertValue(event.getData().get(), Map.class);
        Map additionalDetails = objectMapper.convertValue(data.get("additionalDetails"), Map.class);

        String imageUrl = "https://objectstorage." +
                region +
                ".oraclecloud.com/n/" +
                additionalDetails.get("namespace") +
                "/b/" +
                additionalDetails.get("bucketName") +
                "/o/" +
                data.get("resourceName");

        InputStream imageStream = new URL(imageUrl).openStream();
        Metadata metadata = ImageMetadataReader.readMetadata(imageStream);
        System.out.println(objectMapper.writeValueAsString(metadata));
	
	return metadata;    
}

}
