import React, { useState, useEffect } from 'react';
import { commentStore } from './commentStore';
import './Comment.css';

export const CommentFooter: React.FC = () => {
  const [comments, setComments] = useState(commentStore.getComments());

  useEffect(() => {
    const unsubscribe = commentStore.subscribe(() => {
      setComments(commentStore.getComments());
    });

    // 초기 로드 시 주석 목록 업데이트
    setComments(commentStore.getComments());

    return unsubscribe;
  }, []);

  const scrollToComment = (id: number) => {
    commentStore.scrollToComment(id);
  };

  if (comments.length === 0) {
    return null;
  }

  return (
    <div className="comment-footer" id="comment-footer">
      <ol className="comment-list">
        {comments.map((comment) => (
          <li key={comment.id} className="comment-item" id={`comment-footer-item-${comment.id}`}>
            <span className="comment-number">[{comment.id}]</span>
            <span className="comment-link" onClick={() => scrollToComment(comment.id)}>
              {comment.note}
            </span>
          </li>
        ))}
      </ol>
    </div>
  );
};
