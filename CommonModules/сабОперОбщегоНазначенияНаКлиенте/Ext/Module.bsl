
Процедура ОбработатьЗаполнениеПоШтрихкодуНаКлиенте(Форма, ИмяТЧ, ИмяРеквизитаНоменклатуры, ИмяРеквизитаКоличества, Штрихкод) Экспорт
	Если ЗначениеЗаполнено(Штрихкод) Тогда
		Номенклатура = сабОперОбщегоНазначения.ПодобратНоменклатуруПоШК(Штрихкод);
		Текданные = Форма.Элементы[ИмяТЧ].ТекущиеДанные;
		Если Не Текданные = Неопределено И НЕ ЗначениеЗаполнено(Текданные[ИмяРеквизитаНоменклатуры]) Тогда
			Если ТипЗнч(Номенклатура) = Тип("Структура") Тогда
				ЗаполнитьЗначенияСвойств(ТекДанные, Номенклатура);
				ТекДанные[ИмяРеквизитаНоменклатуры] = Номенклатура.Номенклатура;
			Иначе
				Текданные[ИмяРеквизитаНоменклатуры] = Номенклатура;
			КонецЕсли; 
		Иначе
			Если ТипЗнч(Номенклатура) = Тип("Структура") Тогда				
				НайденныеПозиции = Форма.Объект[ИмяТЧ].НайтиСтроки(Новый Структура(ИмяРеквизитаНоменклатуры, Номенклатура.Номенклатура));
				Если НайденныеПозиции.Количество() Тогда
					НайденныеПозиции[0][ИмяРеквизитаКоличества] = НайденныеПозиции[0][ИмяРеквизитаКоличества] + Номенклатура.Количество;
					Форма.Элементы[ИмяТЧ].ТекущаяСтрока = НайденныеПозиции[0].ПолучитьИдентификатор();
				Иначе
					Форма.Элементы[ИмяТЧ].ДобавитьСтроку();
					Форма.Элементы[ИмяТЧ].ТекущиеДанные[ИмяРеквизитаНоменклатуры] = Номенклатура.Номенклатура;
					Форма.Элементы[ИмяТЧ].ТекущиеДанные[ИмяРеквизитаКоличества] = Номенклатура.Количество;
				КонецЕсли;
			Иначе
				НайденныеПозиции = Форма.Объект[ИмяТЧ].НайтиСтроки(Новый Структура(ИмяРеквизитаНоменклатуры, Номенклатура));
				Если НайденныеПозиции.Количество() Тогда
					Форма.Элементы[ИмяТЧ].ТекущаяСтрока = НайденныеПозиции[0].ПолучитьИдентификатор();
				Иначе
					Форма.Элементы[ИмяТЧ].ДобавитьСтроку();
					Форма.Элементы[ИмяТЧ].ТекущиеДанные[ИмяРеквизитаНоменклатуры] = Номенклатура;
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

Функция ПроверкаСозданияНаОснованииНаКлиенте(Объект, ИмяРеквизита = "Комментарий") Экспорт

	Если СтрНайти(Объект[ИмяРеквизита], "##УжеСоздан") Тогда
		Сообщить("На основании заказа уже был создан документ " + Сред(Объект[ИмяРеквизита], 12) + "!");
		Отказ = Истина;
		Возврат Отказ;
	КонецЕсли;
	
	Если СтрНайти(Объект[ИмяРеквизита], "##НеПроведен") Тогда
		Сообщить("Документ-основание не проведен!");
		Отказ = Истина;
		Возврат Отказ;
	КонецЕсли;
	
	Отказ = Ложь;
	Возврат Отказ;
	
КонецФункции
