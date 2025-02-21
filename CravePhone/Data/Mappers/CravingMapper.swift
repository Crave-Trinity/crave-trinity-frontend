internal struct CravingMapper {
    func mapToEntity(_ dto: CravingDTO) -> CravingEntity {
        CravingEntity(
            id: dto.id,
            text: dto.text,
            timestamp: dto.timestamp,
            isArchived: dto.isArchived
        )
    }
    
    func mapToDTO(_ entity: CravingEntity) -> CravingDTO {
        CravingDTO(
            id: entity.id,
            text: entity.text,
            timestamp: entity.timestamp,
            isArchived: entity.isArchived
        )
    }
}
