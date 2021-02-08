//
// DO NOT EDIT.
//
// Generated by the protocol buffer compiler.
// Source: webservice.proto
//

//
// Copyright 2018, gRPC Authors All rights reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//
import GRPC
import NIO
import SwiftProtobuf


/// Usage: instantiate V1PlayServiceClient, then call methods of this protocol to make API calls.
internal protocol V1PlayServiceClientProtocol: GRPCClient {
  func playmove(
    _ request: PlayMoveMessage,
    callOptions: CallOptions?
  ) -> UnaryCall<PlayMoveMessage, BoolMessageMessage>

}

extension V1PlayServiceClientProtocol {

  /// Unary call to playmove
  ///
  /// - Parameters:
  ///   - request: Request to send to playmove.
  ///   - callOptions: Call options.
  /// - Returns: A `UnaryCall` with futures for the metadata, status and response.
  internal func playmove(
    _ request: PlayMoveMessage,
    callOptions: CallOptions? = nil
  ) -> UnaryCall<PlayMoveMessage, BoolMessageMessage> {
    return self.makeUnaryCall(
      path: "/V1PlayService/playmove",
      request: request,
      callOptions: callOptions ?? self.defaultCallOptions
    )
  }
}

internal final class V1PlayServiceClient: V1PlayServiceClientProtocol {
  internal let channel: GRPCChannel
  internal var defaultCallOptions: CallOptions

  /// Creates a client for the V1PlayService service.
  ///
  /// - Parameters:
  ///   - channel: `GRPCChannel` to the service host.
  ///   - defaultCallOptions: Options to use for each service call if the user doesn't provide them.
  internal init(channel: GRPCChannel, defaultCallOptions: CallOptions = CallOptions()) {
    self.channel = channel
    self.defaultCallOptions = defaultCallOptions
  }
}

/// Usage: instantiate V1SessionjoinServiceClient, then call methods of this protocol to make API calls.
internal protocol V1SessionjoinServiceClientProtocol: GRPCClient {
  func join(
    _ request: JoinSessionMessage,
    callOptions: CallOptions?
  ) -> UnaryCall<JoinSessionMessage, RegisteredUserMessage>

}

extension V1SessionjoinServiceClientProtocol {

  /// Unary call to join
  ///
  /// - Parameters:
  ///   - request: Request to send to join.
  ///   - callOptions: Call options.
  /// - Returns: A `UnaryCall` with futures for the metadata, status and response.
  internal func join(
    _ request: JoinSessionMessage,
    callOptions: CallOptions? = nil
  ) -> UnaryCall<JoinSessionMessage, RegisteredUserMessage> {
    return self.makeUnaryCall(
      path: "/V1SessionjoinService/join",
      request: request,
      callOptions: callOptions ?? self.defaultCallOptions
    )
  }
}

internal final class V1SessionjoinServiceClient: V1SessionjoinServiceClientProtocol {
  internal let channel: GRPCChannel
  internal var defaultCallOptions: CallOptions

  /// Creates a client for the V1SessionjoinService service.
  ///
  /// - Parameters:
  ///   - channel: `GRPCChannel` to the service host.
  ///   - defaultCallOptions: Options to use for each service call if the user doesn't provide them.
  internal init(channel: GRPCChannel, defaultCallOptions: CallOptions = CallOptions()) {
    self.channel = channel
    self.defaultCallOptions = defaultCallOptions
  }
}

/// Usage: instantiate V1SessionpollServiceClient, then call methods of this protocol to make API calls.
internal protocol V1SessionpollServiceClientProtocol: GRPCClient {
  func poll(
    _ request: PollSessionMessage,
    callOptions: CallOptions?
  ) -> UnaryCall<PollSessionMessage, GameStateMessage>

}

extension V1SessionpollServiceClientProtocol {

  /// Unary call to poll
  ///
  /// - Parameters:
  ///   - request: Request to send to poll.
  ///   - callOptions: Call options.
  /// - Returns: A `UnaryCall` with futures for the metadata, status and response.
  internal func poll(
    _ request: PollSessionMessage,
    callOptions: CallOptions? = nil
  ) -> UnaryCall<PollSessionMessage, GameStateMessage> {
    return self.makeUnaryCall(
      path: "/V1SessionpollService/poll",
      request: request,
      callOptions: callOptions ?? self.defaultCallOptions
    )
  }
}

internal final class V1SessionpollServiceClient: V1SessionpollServiceClientProtocol {
  internal let channel: GRPCChannel
  internal var defaultCallOptions: CallOptions

  /// Creates a client for the V1SessionpollService service.
  ///
  /// - Parameters:
  ///   - channel: `GRPCChannel` to the service host.
  ///   - defaultCallOptions: Options to use for each service call if the user doesn't provide them.
  internal init(channel: GRPCChannel, defaultCallOptions: CallOptions = CallOptions()) {
    self.channel = channel
    self.defaultCallOptions = defaultCallOptions
  }
}

/// To build a server, implement a class that conforms to this protocol.
internal protocol V1PlayServiceProvider: CallHandlerProvider {
  func playmove(request: PlayMoveMessage, context: StatusOnlyCallContext) -> EventLoopFuture<BoolMessageMessage>
}

extension V1PlayServiceProvider {
  internal var serviceName: Substring { return "V1PlayService" }

  /// Determines, calls and returns the appropriate request handler, depending on the request's method.
  /// Returns nil for methods not handled by this service.
  internal func handleMethod(_ methodName: Substring, callHandlerContext: CallHandlerContext) -> GRPCCallHandler? {
    switch methodName {
    case "playmove":
      return CallHandlerFactory.makeUnary(callHandlerContext: callHandlerContext) { context in
        return { request in
          self.playmove(request: request, context: context)
        }
      }

    default: return nil
    }
  }
}

/// To build a server, implement a class that conforms to this protocol.
internal protocol V1SessionjoinServiceProvider: CallHandlerProvider {
  func join(request: JoinSessionMessage, context: StatusOnlyCallContext) -> EventLoopFuture<RegisteredUserMessage>
}

extension V1SessionjoinServiceProvider {
  internal var serviceName: Substring { return "V1SessionjoinService" }

  /// Determines, calls and returns the appropriate request handler, depending on the request's method.
  /// Returns nil for methods not handled by this service.
  internal func handleMethod(_ methodName: Substring, callHandlerContext: CallHandlerContext) -> GRPCCallHandler? {
    switch methodName {
    case "join":
      return CallHandlerFactory.makeUnary(callHandlerContext: callHandlerContext) { context in
        return { request in
          self.join(request: request, context: context)
        }
      }

    default: return nil
    }
  }
}

/// To build a server, implement a class that conforms to this protocol.
internal protocol V1SessionpollServiceProvider: CallHandlerProvider {
  func poll(request: PollSessionMessage, context: StatusOnlyCallContext) -> EventLoopFuture<GameStateMessage>
}

extension V1SessionpollServiceProvider {
  internal var serviceName: Substring { return "V1SessionpollService" }

  /// Determines, calls and returns the appropriate request handler, depending on the request's method.
  /// Returns nil for methods not handled by this service.
  internal func handleMethod(_ methodName: Substring, callHandlerContext: CallHandlerContext) -> GRPCCallHandler? {
    switch methodName {
    case "poll":
      return CallHandlerFactory.makeUnary(callHandlerContext: callHandlerContext) { context in
        return { request in
          self.poll(request: request, context: context)
        }
      }

    default: return nil
    }
  }
}
