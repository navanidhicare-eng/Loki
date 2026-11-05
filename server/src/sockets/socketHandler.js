module.exports = (io) => {
  io.on('connection', (socket) => {
    console.log(`[Socket] Client connected: ${socket.id}`);

    // Join room based on user role / id
    socket.on('join', ({ userId, role }) => {
      if (role === 'admin') {
        socket.join('admin_room');
      }
      if (role === 'provider' && userId) {
        socket.join(`provider_${userId}`);
      }
      if (role === 'customer' && userId) {
        socket.join(`customer_${userId}`);
      }
      console.log(`[Socket] User ${userId} (${role}) joined their notification channel`);
    });

    // Real-time location broadcast from provider app
    socket.on('provider:stream_location', (data) => {
      // data: { providerId, orderId, lat, lng }
      if (data.orderId) {
        io.to(`order_${data.orderId}`).emit('provider:live_location', data);
      }
      io.to('admin_room').emit('provider:live_location', data);
    });

    socket.on('order:join_tracking', ({ orderId }) => {
      socket.join(`order_${orderId}`);
      console.log(`[Socket] Client joined tracking for order: ${orderId}`);
    });

    socket.on('disconnect', () => {
      console.log(`[Socket] Client disconnected: ${socket.id}`);
    });
  });
};
