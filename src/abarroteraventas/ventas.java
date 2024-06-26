package abarroteraventas;

import java.util.ArrayList;
import java.util.Date;
import java.util.Scanner;

/**
 *
 * @author Alexis Reyes
 */
public class ventas {
    private static int ventaID;
    private int id;
    private Date fechaVenta;
    private String cliente;
    private ArrayList<productos> vendidos;
    private float importeTot;

    public ventas() {
        ventaID++;
        id = ventaID;
    }

    public ventas(Date fechaVenta, String cliente, ArrayList<productos> vendidos, float importeTot) {
        ventaID++;
        id = ventaID;
        this.fechaVenta = fechaVenta;
        this.cliente = cliente;
        this.importeTot = importeTot;
        this.vendidos = vendidos;
    }

    private float calcularImporteTotal() {
        float total = 0;
        for (productos producto : vendidos) {
            total += producto.getPrecio();
        }
        return total;
    }

    public void registrarVenta(ventas v, productos p, ArrayList<productos> lista, ArrayList<ventas> ventas) {
        System.out.println("\n==============================");
        System.out.println("        Registro de ventas");
        System.out.println("==============================\n");

        System.out.print("Introduce el nombre del cliente: ");
        Scanner entrada = new Scanner(System.in);
        v.setCliente(entrada.nextLine());

        p.listaProductos(lista);

        System.out.println("\nSeleccione los productos (Ingrese 0 para terminar):");
        int seleccionar;
        do {
            System.out.print("ID del producto: ");
            seleccionar = entrada.nextInt();
            if (seleccionar != 0) {
                boolean found = false;
                for (productos product : lista) {
                    if (product.getProductoID() == seleccionar) {
                        if (product.getStock() > 0) {
                            if (v.getVendidos() == null) {
                                v.setVendidos(new ArrayList<>());
                            }
                            v.getVendidos().add(product);
                            product.setStock(product.getStock() - 1); // Reduce stock by 1
                            found = true;
                            System.out.println("Producto añadido a la venta. Stock restante: " + product.getStock());
                        } else {
                            System.out.println("Producto sin stock. No se puede añadir a la venta.");
                        }
                        break;
                    }
                }
                if (!found) {
                    System.out.println("Producto no encontrado. Por favor, seleccione un producto válido.");
                }
            }
        } while (seleccionar != 0);
        v.setImporteTot(v.calcularImporteTotal());
        ventas.add(v);
    }

    public void mostrarVentas(ArrayList<ventas> listaV) {
        if (listaV.isEmpty()) {
            System.out.println("La lista de pedidos está vacía");
        } else {
            System.out.println("\n====================================");
            System.out.println("      Mostrar lista de ventas");
            System.out.println("====================================\n");

            for (ventas venta : listaV) {
                System.out.println("ID de venta: " + venta.getVentaID());
                System.out.println("Nombre del cliente: " + venta.getCliente());
                System.out.println("Fecha: " + (venta.getFechaVenta()));

                System.out.println("Productos de la venta:");

                for (productos product : venta.vendidos) {
                    System.out.println("\nNúmero de producto: " + product.getProductoID());
                    System.out.println("Nombre: " + product.getNombre());
                    System.out.println("Descripción: " + product.getDescripcion());
                    System.out.println("Costo: " + product.getPrecio());
                    System.out.println("Stock: " + product.getStock());
                    System.out.println("----------------------------------------------");
                }
            }
        }
    }

    public void consultarVentaPorID(ArrayList<ventas> listaV, int id) {
        for (ventas venta : listaV) {
            if (venta.getVentaID() == id) {
                System.out.println("\n====================================");
                System.out.println("         Detalles de la Venta");
                System.out.println("====================================\n");
                System.out.println("ID de venta: " + venta.getVentaID());
                System.out.println("Nombre del cliente: " + venta.getCliente());
                System.out.println("Fecha: " + (venta.getFechaVenta()));
                System.out.println("Importe total: " + venta.getImporteTot());
                System.out.println("Productos de la venta:");

                for (productos product : venta.vendidos) {
                    System.out.println("\nNúmero de producto: " + product.getProductoID());
                    System.out.println("Nombre: " + product.getNombre());
                    System.out.println("Descripción: " + product.getDescripcion());
                    System.out.println("Costo: " + product.getPrecio());
                    System.out.println("Stock: " + product.getStock());
                    System.out.println("----------------------------------------------");
                }
                return; // Terminate after finding and displaying the sale
            }
        }
        System.out.println("Venta no encontrada.");
    }
    
    public void eliminarVenta(ArrayList<ventas> listaV, ArrayList<productos> listaP, int id) {
    for (int i = 0; i < listaV.size(); i++) {
        ventas venta = listaV.get(i);
        if (venta.getVentaID() == id) {
            for (productos producto : venta.getVendidos()) {
                for (productos p : listaP) {
                    if (p.getProductoID() == producto.getProductoID()) {
                        p.setStock(p.getStock() + 1); 
                        break;
                    }
                }
            }
            System.out.println("Venta eliminada exitosamente.");
            return;
        }
    }
    System.out.println("Venta no encontrada.");
}
    
    public void agregarProductoAVenta(ArrayList<ventas> listaV, ArrayList<productos> listaP, int idVenta, int idProducto) {
    for (ventas venta : listaV) {
        if (venta.getVentaID() == idVenta) {
            for (productos producto : listaP) {
                if (producto.getProductoID() == idProducto) {
                    if (producto.getStock() > 0) {
                        if (venta.getVendidos() == null) {
                            venta.setVendidos(new ArrayList<>());
                        }
                        venta.getVendidos().add(producto);
                        producto.setStock(producto.getStock() - 1);
                        venta.setImporteTot(venta.calcularImporteTotal());
                        System.out.println("Producto agregado exitosamente a la venta.");
                    } else {
                        System.out.println("No hay suficiente stock para el producto.");
                    }
                    return;
                }
            }
            System.out.println("Producto no encontrado.");
            return;
        }
    }
    System.out.println("Venta no encontrada.");
}
    
    public void eliminarProductoDeVenta(ArrayList<ventas> listaV, ArrayList<productos> listaP, int idVenta, int idProducto) {
    for (ventas venta : listaV) {
        if (venta.getVentaID() == idVenta) {
            if (venta.getVendidos() != null) {
                for (int i = 0; i < venta.getVendidos().size(); i++) {
                    productos producto = venta.getVendidos().get(i);
                    if (producto.getProductoID() == idProducto) {
                        for (productos p : listaP) {
                            if (p.getProductoID() == idProducto) {
                                p.setStock(p.getStock() + 1); // Aumentar el stock en 1
                                break;
                            }
                        }
                        venta.getVendidos().remove(i);
                        venta.setImporteTot(venta.calcularImporteTotal());
                        System.out.println("Producto eliminado de la venta exitosamente.");
                        return;
                    }
                }
                System.out.println("Producto no encontrado en la venta.");
            } else {
                System.out.println("No hay productos vendidos en esta venta.");
            }
            return;
        }
    }
    System.out.println("Venta no encontrada.");
}


    // Getters and setters

    public int getVentaID() {
        return id;
    }

    public void setVentaID(int aVentaID) {
        id = aVentaID;
    }

    public Date getFechaVenta() {
        return fechaVenta;
    }

    public void setFechaVenta(Date fechaVenta) {
        this.fechaVenta = fechaVenta;
    }

    public String getCliente() {
        return cliente;
    }

    public void setCliente(String cliente) {
        this.cliente = cliente;
    }

    public ArrayList<productos> getVendidos() {
        return vendidos;
    }

    public void setVendidos(ArrayList<productos> vendidos) {
        this.vendidos = vendidos;
    }

    public float getImporteTot() {
        return importeTot;
    }

    public void setImporteTot(float importeTot) {
        this.importeTot = importeTot;
    }
}
