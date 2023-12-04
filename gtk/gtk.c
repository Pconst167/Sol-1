#include <gtk/gtk.h>

// Callback function for the button click event
static void on_button_clicked(GtkWidget *widget, gpointer data) {
    g_print("Button clicked!\n");
}

int main(int argc, char *argv[]) {
    GtkWidget *window;
    GtkWidget *button;
    GtkWidget *grid;

    // Initialize GTK
    gtk_init(&argc, &argv);

    // Create a new window
    window = gtk_window_new(GTK_WINDOW_TOPLEVEL);
    gtk_window_set_title(GTK_WINDOW(window), "Button Size and Position");
    gtk_window_set_default_size(GTK_WINDOW(window), 300, 200);
    g_signal_connect(window, "destroy", G_CALLBACK(gtk_main_quit), NULL);

    // Create a grid
    grid = gtk_grid_new();
    gtk_container_add(GTK_CONTAINER(window), grid);

    // Create a new button
    button = gtk_button_new_with_label("Click me");
    g_signal_connect(button, "clicked", G_CALLBACK(on_button_clicked), NULL);

    // Set button size
    gtk_widget_set_size_request(button, 100, 50);

    // Add the button to the grid
    gtk_grid_attach(GTK_GRID(grid), button, 0, 0, 1, 1);

    // Show the window and all its contents
    gtk_widget_show_all(window);

    // Run the GTK main loop
    gtk_main();

    return 0;
}
