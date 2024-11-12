import java.io.File;
import java.io.FileWriter;
import java.io.BufferedWriter;
import java.io.FileReader;
import java.io.BufferedReader;
import java.io.IOException;
import java.util.ArrayList;

class FileHandler {
  String fileName;
  BufferedWriter writer;
  BufferedReader reader;
  FileWriter fileWriter;
  FileReader fileReader;

  FileHandler(String fileName) {
    this.fileName = fileName;
  }

  // Método para abrir el archivo en modo de adición (si no existe, se crea)
  void openForAppending() {
    File f = new File(fileName);
    if (!f.exists()) {
      createFile(f); // Crear el archivo si no existe
    }
    try {
      // Abrir el archivo para escritura en modo de adición
      fileWriter = new FileWriter(f, true); 
      writer = new BufferedWriter(fileWriter);
    } catch (IOException e) {
      println("Error al abrir el archivo para adición: " + e);
    }
  }

  // Método para escribir en el archivo
  void writeToFile(float x, float y, float z) {
    try {
      if (writer != null) {
        // Escribir los valores de x, y, z como una línea en el formato x,y,z
        writer.write(x + "," + y + "," + z); 
        writer.newLine();    // Agregar nueva línea al final
      }
    } catch (IOException e) {
      println("Error al escribir en el archivo: " + e);
    }
  }

  // Método para cerrar el escritor
  void closeWriter() {
    try {
      if (writer != null) {
        writer.close();
      }
    } catch (IOException e) {
      println("Error al cerrar el archivo: " + e);
    }
  }

  // Método para abrir el archivo para lectura
  void openForReading() {
    try {
      // Abrir el archivo para lectura
      fileReader = new FileReader(fileName);
      reader = new BufferedReader(fileReader);
    } catch (IOException e) {
      println("Error al abrir el archivo para lectura: " + e);
    }
  }

  // Método para leer una línea del archivo y devolver un PVector
  PVector readFromFile() {
    String line = null;
    try {
      if (reader != null) {
        line = reader.readLine(); // Leer una línea del archivo
      }
    } catch (IOException e) {
      println("Error al leer desde el archivo: " + e);
    }

    // Verificar si la línea no es null
    if (line != null) {
      String[] components = line.split(","); // Separar la línea en componentes
      if (components.length == 3) {
        // Convertir las cadenas a números flotantes
        float x = Float.parseFloat(components[0]);
        float y = Float.parseFloat(components[1]);
        float z = Float.parseFloat(components[2]);
        // Crear y devolver un PVector con los valores leídos
        return new PVector(x, y, z);
      } else {
        println("Error: El formato del archivo no es válido.");
        return null;
      }
    }

    // Si no se pudo leer nada, devolver null
    return null;
  }

  // Método para leer todo el archivo y devolver una lista de PVectors
  ArrayList<PVector> readAllFromFile() {
    ArrayList<PVector> vectors = new ArrayList<PVector>();
    String line = null;
    try {
      if (reader != null) {
        while ((line = reader.readLine()) != null) {
          String[] components = line.split(",");
          if (components.length == 3) {
            float x = Float.parseFloat(components[0]);
            float y = Float.parseFloat(components[1]);
            float z = Float.parseFloat(components[2]);
            vectors.add(new PVector(x, y, z));
          }
        }
      }
    } catch (IOException e) {
      println("Error al leer desde el archivo: " + e);
    }
    return vectors;
  }

  // Método para cerrar el lector
  void closeReader() {
    try {
      if (reader != null) {
        reader.close();
      }
    } catch (IOException e) {
      println("Error al cerrar el lector: " + e);
    }
  }

  // Método para crear un archivo, incluyendo las subcarpetas si no existen
  void createFile(File f) {
    File parentDir = f.getParentFile();
    try {
      if (!parentDir.exists()) {
        parentDir.mkdirs(); // Crear subdirectorios si no existen
      }
      f.createNewFile(); // Crear el archivo
    } catch (IOException e) {
      println("Error al crear el archivo: " + e);
    }
  }
}
