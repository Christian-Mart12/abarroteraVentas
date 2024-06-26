package abarroteraventas;

import java.util.ArrayList;
import java.util.Scanner;

/**
 *
 * @author Alexis Reyes
 */
public class productos {
    private static int productoID = -1;
    private int id;
    private String nombre;
    private String descripcion;
    private float precio;
    private int stock;

    public productos() {
        productoID++;
        id = productoID;
    }

    public productos(String nombre, String descripcion, float precio, int stock) {
        productoID++;
        id = productoID;
        this.nombre = nombre;
        this.descripcion = descripcion;
        this.precio = precio;
        this.stock = stock;
    }

    public void registrarProductos(ArrayList<productos> registro) {
        Scanner entrada = new Scanner(System.in);

        System.out.println("\n========================");
        System.out.println("    Registrar Producto");
        System.out.println("========================\n");

        System.out.print("Introduce el nombre del producto: ");
        String nombre = entrada.nextLine();

        System.out.print("Introduce la descripción del producto: ");
        String descripcion = entrada.nextLine();

        System.out.print("Introduce el precio del producto: ");
        float precio = entrada.nextFloat();

        System.out.print("Introduce el stock que hay disponible del producto: ");
        int stock = entrada.nextInt();

        productos nuevoProducto = new productos(nombre, descripcion, precio, stock);
        registro.add(nuevoProducto);
    }

    public void listaProductos(ArrayList<productos> registro) {
        if (registro.isEmpty()) {
            System.out.println("La lista de productos está vacía.");
        } else {
            System.out.println("\n========================");
            System.out.println("   Lista de productos");
            System.out.println("========================\n");

            for (productos producto : registro) {
                System.out.println("ID del producto: " + producto.getProductoID());
                System.out.println("Nombre del producto: " + producto.getNombre());
                System.out.println("Stock disponible del producto: " + producto.getStock());
                System.out.println();
            }
        }
    }

    public void actualizarPrecio(productos p, ArrayList<productos> registro) {
        Scanner entrada = new Scanner(System.in);

        System.out.print("Introduce el ID del producto: ");
        int id = entrada.nextInt();

        productos producto = buscarProductoPorID(id, registro);
        if (producto != null) {
            System.out.print("Introduce el nuevo precio del producto: ");
            float nuevoPrecio = entrada.nextFloat();
            producto.setPrecio(nuevoPrecio);
            System.out.println("Precio actualizado correctamente.");
        } else {
            System.out.println("Producto no encontrado.");
        }
    }

    private productos buscarProductoPorID(int id, ArrayList<productos> registro) {
        for (productos producto : registro) {
            if (producto.getProductoID() == id) {
                return producto;
            }
        }
        return null;
    }

    // Getters and setters

    public int getProductoID() {
        return id;
    }

    public void setProductoID(int aProductoID) {
        id = aProductoID;
    }

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public String getDescripcion() {
        return descripcion;
    }

    public void setDescripcion(String descripcion) {
        this.descripcion = descripcion;
    }

    public float getPrecio() {
        return precio;
    }

    public void setPrecio(float precio) {
        this.precio = precio;
    }

    public int getStock() {
        return stock;
    }

    public void setStock(int stock) {
        this.stock = stock;
    }
}
